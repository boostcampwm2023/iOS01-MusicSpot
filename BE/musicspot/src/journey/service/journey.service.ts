import { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import { Injectable } from '@nestjs/common';

import { StartJourneyReqDTO } from '../dto/journeyStart/journeyStartReq.dto';
import { Journey } from '../schema/journey.schema';

import { User } from '../../user/schema/user.schema';
// import { EndJourneyDTO } from '../dto/journeyEnd/journeyEndReq.dto';
// import { RecordJourneyDTO } from '../dto/journeyRecord/journeyRecordReq.dto';
import { CheckJourneyDTO } from '../dto/journeyCheck/journeyCheckReq.dto';
import { JourneyNotFoundException } from '../../filters/journey.exception';
import { UserNotFoundException } from '../../filters/user.exception';
import { Song } from '../schema/song.schema';
import * as turf from '@turf/turf';
import { LoadJourneyDTO } from '../dto/journeyLoad.dto';

import {
  EndJourneyReqDTO,
  EndJourneyResDTO,
} from '../dto/journeyEnd/journeyEnd.dto';
import { RecordJourneyReqDTO } from '../dto/journeyRecord/journeyRecord.dto';

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
    // const coordinateToAdd = Array.isArray(coordinate[0])
    //   ? coordinate
    //   : [coordinate];
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
    // coordinate가 단일 배열인 경우 이를 이중 배열로 감싸서 처리

    // const coordinateToAdd = Array.isArray(coordinate[0])
    //   ? coordinate
    //   : [coordinate];
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
    // const { coordinates } = updatedJourney;
    // const len = coordinates.length;
    // return { coordinate: coordinates[len - 1] };
  }

  async checkJourney(checkJourneyDTO: CheckJourneyDTO) {
    const { userId, minCoordinate, maxCoordinate } = checkJourneyDTO;
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

    const journeyList = await this.findMinMaxCoordinates(boundingBox, journeys);
    return journeyList;
  }
  async findMinMaxCoordinates(boundingBox, journeys) {
    let journeyList = [];

    for (let i = 0; i < journeys.length; i++) {
      let journey = await this.journeyModel.findById(journeys[i]).lean();
      if (!journey) {
        throw new JourneyNotFoundException();
      }
      let journeyLine = turf.lineString(journey.coordinates);
      if (turf.booleanWithin(journeyLine, boundingBox)) {
        journeyList.push(journey);
      }
    }
    return journeyList;
  }
  async loadLastJourney(userId) {
    const user = await this.userModel.findById(userId).lean();

    if (!user) {
      throw new UserNotFoundException();
    }
    const journeys = user.journeys;

    const journey = await this.findLastJourney(journeys);
    if (journey) {
      return journey;
    }
    return '진행중이었던 여정이 없습니다.';
  }
  async findLastJourney(journeys) {
    for (let i = 0; i < journeys.length; i++) {
      let journey = await this.journeyModel.findById(journeys[i]).lean();
      if (!journey) {
        throw new JourneyNotFoundException();
      }
      if (journey.title === '') {
        return journey;
      }
    }
    return false;
  }
}
