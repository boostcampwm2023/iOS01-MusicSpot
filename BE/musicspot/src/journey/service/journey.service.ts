import mongoose, { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import { Injectable } from '@nestjs/common';

import { StartJourneyReqDTO } from '../dto/journeyStart/journeyStart.dto';
import { Journey } from '../schema/journey.schema';

import { User } from '../../user/schema/user.schema';
import {
  JourneyNotFoundException,
  coordinateNotCorrectException,
} from '../../filters/journey.exception';
import { UserNotFoundException } from '../../filters/user.exception';
import * as turf from '@turf/turf';
import { LoadJourneyDTO } from '../dto/journeyLoad.dto';
import {
  S3,
  bucketName,
  makePresignedUrl,
} from '../../common/s3/objectStorage';
import { EndJourneyReqDTO } from '../dto/journeyEnd/journeyEnd.dto';
import { CheckJourneyReqDTO } from '../dto/journeyCheck/journeyCheck.dto';
import { RecordJourneyReqDTO } from '../dto/journeyRecord/journeyRecord.dto';
import { is1DArray } from 'src/common/util/coordinate.util';
import { DeleteJourneyReqDTO } from '../dto/journeyDelete.dto';
import { checkPrimeSync } from 'crypto';

@Injectable()
export class JourneyService {
  constructor(
    @InjectModel(Journey.name) private journeyModel: Model<Journey>,
    @InjectModel(User.name) private userModel: Model<User>,
  ) {}
  async insertJourneyData(startJourneyDTO: StartJourneyReqDTO) {
    const journeyData: Journey = {
      ...startJourneyDTO,
      coordinates: [startJourneyDTO.coordinate],
      spots: [],
      journeyMetadata: {
        startTimestamp: startJourneyDTO.startTimestamp,
        endTimestamp: '',
      },
    };
    const createdJourneyData = new this.journeyModel(journeyData);
    return await createdJourneyData.save();
  }
  async pushJourneyIdToUser(journeyId, userId) {
    const result = await this.userModel
      .findOneAndUpdate(
        { userId },
        { $push: { journeys: journeyId } },
        { new: true },
      )
      .lean();
    if (!result) {
      new UserNotFoundException();
    }
    return result;
  }

  async create(startJourneyDTO: StartJourneyReqDTO) {
    const createdJourneyData = await this.insertJourneyData(startJourneyDTO);
    const updateUserInfo = await this.pushJourneyIdToUser(
      createdJourneyData._id,
      startJourneyDTO.userId,
    );
    const { coordinates, journeyMetadata, _id } = createdJourneyData;
    const [coordinate] = coordinates;
    const { startTimestamp } = journeyMetadata;
    return { coordinate, startTimestamp, journeyId: _id };
  }

  async end(endJourneyDTO: EndJourneyReqDTO) {
    const { journeyId, title, coordinates, endTimestamp, song } = endJourneyDTO;

    const coordinatesLen = coordinates.length;

    const updatedJourney = await this.journeyModel
      .findOneAndUpdate(
        { _id: journeyId },
        {
          $set: { title, song, 'journeyMetadata.endTimestamp': endTimestamp },
          $push: { coordinates: { $each: coordinates } },
        },
        { new: true },
      )
      .lean();

    if (!updatedJourney) {
      throw new JourneyNotFoundException();
    }

    const updatedCoordinates = updatedJourney.coordinates;
    const updatedEndTimestamp = updatedJourney.journeyMetadata.endTimestamp;
    const updatedId = updatedJourney._id;
    const updatedSong = updatedJourney.song;
    const updatedCoordinatesLen = coordinates.length;
    const totalCoordinatesLen = updatedCoordinates.length;
    const slicedCoordinates = updatedCoordinates.slice(-updatedCoordinatesLen);
    return {
      id: updatedId,
      coordinates: slicedCoordinates,
      endTimestamp: updatedEndTimestamp,
      song: updatedSong,
      numberOfCoordinates: totalCoordinatesLen,
    };
  }

  async pushCoordianteToJourney(recordJourneyDTO: RecordJourneyReqDTO) {
    const { journeyId, coordinates } = recordJourneyDTO;
    const coordinatesLen = coordinates.length;

    const updatedJourney = await this.journeyModel
      .findOneAndUpdate(
        { _id: journeyId },
        { $push: { coordinates: { $each: coordinates } } },
        { new: true },
      )
      .lean();
    if (!updatedJourney) {
      throw new JourneyNotFoundException();
    }
    const updatedCoordinates = updatedJourney.coordinates;
    return { coordinates: updatedCoordinates.slice(-coordinatesLen) };
  }

  async checkJourney(checkJourneyDTO) {
    let { userId, minCoordinate, maxCoordinate } = checkJourneyDTO;
    if (!(Array.isArray(minCoordinate) && Array.isArray(maxCoordinate))) {
      throw new coordinateNotCorrectException();
    }
    minCoordinate = minCoordinate.map((item) => parseFloat(item));
    maxCoordinate = maxCoordinate.map((item) => parseFloat(item));

    if (!(is1DArray(minCoordinate) && is1DArray(maxCoordinate))) {
      throw new coordinateNotCorrectException();
    }
    const user = await this.userModel.findOne({ userId }).lean();
    if (!user) {
      throw new UserNotFoundException();
    }
    const journeys = user.journeys;
    const boundingBox = turf.bboxPolygon([
      minCoordinate[0],
      minCoordinate[1],
      maxCoordinate[0],
      maxCoordinate[1],
    ]);
    // console.log(boundingBox);
    const journeyList = await this.findMinMaxCoordinates(boundingBox, journeys);
    return journeyList;
  }
  async findMinMaxCoordinates(boundingBox, journeys) {
    let journeyList = [];

    for (let i = 0; i < journeys.length; i++) {
      let journey = await this.findByIdWithPopulate(
        journeys[i],
        'spots',
        'Spot',
        {
          transform: (spot) => {
            return {
              coordinate: spot.coordinate,
              timestamp: spot.timestamp,
              photoUrl: makePresignedUrl(spot.photoKey),
            };
          },
        },
      );
      if (!journey) {
        throw new JourneyNotFoundException();
      }
      if (journey.coordinates.length < 2) {
        continue;
      }
      let journeyLine = turf.lineString(journey.coordinates);
      if (!turf.booleanDisjoint(journeyLine, boundingBox)) {
        journeyList.push(journey);
      }
    }
    return journeyList;
  }

  async loadLastJourney(userId) {
    // const user = await this.userModel.findById(userId).lean();
    const user = await this.userModel.findOne({ userId }).lean();
    if (!user) {
      throw new UserNotFoundException();
    }

    const journeys = user.journeys;
    const len = journeys.length;
    const lastJourneyId = journeys[len - 1];

    const lastJourney = await this.journeyModel
      .findById(lastJourneyId)
      .populate({
        path: 'spots',
        model: 'Spot',
        options: {
          transform: (spot) => {
            return {
              coordinate: spot.coordinate,
              timestamp: spot.timestamp,
              photoUrl: makePresignedUrl(spot.photoKey),
            };
          },
        },
      })
      .lean();

    if (!lastJourney) {
      return {
        journey: null,
        isRecording: false,
      };
    }

    return {
      journey: lastJourney.title ? null : lastJourney,
      isRecording: lastJourney.title ? false : true,
    };
    // returnData['isRecording'] = lastJourney.title ? true : false;
    // returnData['journey'] = lastJourney;

    // return returnData;
    // const journey = await this.findLastJourney(journeys);
    // if (journey) {
    //   return journey;
    // }
    // return '진행중이었던 여정이 없습니다.';
  }
  // async findLastJourney(journeys) {
  //   for (let i = 0; i < journeys.length; i++) {
  //     let journey = await this.journeyModel.findById(journeys[i]).lean();
  //     if (!journey) {
  //       throw new JourneyNotFoundException();
  //     }
  //     if (journey.title === '') {
  //       return journey;
  //     }
  //   }
  //   return false;
  // }

  async getJourneyById(journeyId) {
    return await this.findByIdWithPopulate(journeyId, 'spots', 'Spot', {
      transform: (spot) => {
        return {
          coordinate: spot.coordinate,
          timestamp: spot.timestamp,
          photoUrl: makePresignedUrl(spot.photoKey),
        };
      },
    });
  }

  async findByIdWithPopulate(id, path, model, options?) {
    return await this.journeyModel
      .findById(id)
      .populate({
        path,
        model,
        options,
      })
      .lean();
  }

  async deleteJourneyById(deletedJourneyDto: DeleteJourneyReqDTO) {
    const { userId, journeyId } = deletedJourneyDto;

    const deletedJourney = await this.journeyModel
      .findOneAndDelete({
        _id: journeyId,
      })
      .lean();
    if (!deletedJourney) {
      throw new JourneyNotFoundException();
    }

    const deletedUserData = await this.userModel.findOneAndUpdate(
      { userId },
      { $pull: { journeys: new mongoose.Types.ObjectId(journeyId) } },
      { new: true },
    );

    if (!deletedUserData) {
      throw new UserNotFoundException();
    }

    return deletedJourney;
  }
}
