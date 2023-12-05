import { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import { Injectable } from '@nestjs/common';
import { StartJourneyDTO } from '../dto/journeyStart/journeyStart.dto';
import { Journey } from '../schema/journey.schema';

import { User } from '../../user/schema/user.schema';
import { EndJourneyDTO } from '../dto/journeyEnd.dto';
import { RecordJourneyDTO } from '../dto/journeyRecord.dto';
import { CheckJourneyDTO } from '../dto/journeyCheck.dto';
import { JourneyNotFoundException } from '../../filters/journey.exception';
import { UserNotFoundException } from '../../filters/user.exception';
import { Song } from '../schema/song.schema';
@Injectable()
export class JourneyService {
  constructor(
    @InjectModel(Journey.name) private journeyModel: Model<Journey>,
    @InjectModel(User.name) private userModel: Model<User>,
  ) {}
  async insertJourneyData(startJourneyDTO: StartJourneyDTO) {
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
  async create(startJourneyDTO: StartJourneyDTO): Promise<StartJourneyDTO> {
    const createdJourneyData = await this.insertJourneyData(startJourneyDTO);
    const updateUserInfo = await this.pushJourneyIdToUser(
      createdJourneyData._id,
      startJourneyDTO.userId,
    );
    const { coordinates, journeyMetadata } = createdJourneyData;
    const [coordinate] = coordinates;
    const { startTimestamp } = journeyMetadata;
    const { userId } = updateUserInfo;
    return { coordinate, startTimestamp, userId };
  }

  async end(endJourneyDTO: EndJourneyDTO) {
    const { journeyId, title, coordinate, endTime, song } = endJourneyDTO;
    const coordinateToAdd = Array.isArray(coordinate[0])
      ? coordinate
      : [coordinate];
    const updatedJourney = await this.journeyModel
      .findOneAndUpdate(
        { _id: journeyId },
        {
          $set: { title, song, 'journeyMetadata.endTimestamp': endTime },
          $push: { coordinates: { $each: coordinateToAdd } },
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
    const updatedCoordinatesLen = updatedCoordinates.length;
    const updatedCoordinate = updatedCoordinates[updatedCoordinatesLen - 1];
    return {
      id: updatedId,
      coordinate: updatedCoordinate,
      endTimestamp: updatedEndTimestamp,
      song: updatedSong,
      numberOfCoordinates: updatedCoordinatesLen,
    };
  }

  async pushCoordianteToJourney(recordJourneyDTO: RecordJourneyDTO) {
    const { journeyId, coordinate } = recordJourneyDTO;
    // coordinate가 단일 배열인 경우 이를 이중 배열로 감싸서 처리

    const coordinateToAdd = Array.isArray(coordinate[0])
      ? coordinate
      : [coordinate];
    const updatedJourney = await this.journeyModel
      .findOneAndUpdate(
        { _id: journeyId },
        { $push: { coordinates: { $each: coordinateToAdd } } },
        { new: true },
      )
      .lean();
    if (!updatedJourney) {
      throw new JourneyNotFoundException();
    }
    const { coordinates } = updatedJourney;
    const len = coordinates.length;
    return { coordinate: coordinates[len - 1] };
  }

  async checkJourney(checkJourneyDTO: CheckJourneyDTO) {
    const { userId, minCoordinate, maxCoordinate } = checkJourneyDTO;
    const user = await this.userModel.findById(userId).lean();

    if (!user) {
      throw new UserNotFoundException();
    }
    const journeys = user.journeys;
    const journeyList = await this.findMinMaxCoordinates(
      journeys,
      minCoordinate,
      maxCoordinate,
    );
    return journeyList;
  }
  async findMinMaxCoordinates(journeys, minCoordinate, maxCoordinate) {
    let journeyList = [];
    for (let i = 0; i < journeys.length; i++) {
      let journey = await this.journeyModel.findById(journeys[i]).lean();
      if (!journey) {
        throw new JourneyNotFoundException();
      }
      let chk = true;
      for (const [x, y] of journey.coordinates) {
        if (
          !(
            x > minCoordinate[0] &&
            y > minCoordinate[1] &&
            x < maxCoordinate[0] &&
            y < maxCoordinate[1]
          )
        ) {
          chk = false;
          break;
        }
      }
      if (chk) {
        journeyList.push(journey);
      }
    }
    return journeyList;
  }
}
