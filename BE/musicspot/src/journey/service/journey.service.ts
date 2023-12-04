import { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import { Injectable } from '@nestjs/common';
import { StartJourneyDTO } from '../dto/journeyStart.dto';
import { Journey } from '../schema/journey.schema';

import { User } from '../../user/schema/user.schema';
import { EndJourneyDTO } from '../dto/journeyEnd.dto';
import { RecordJourneyDTO } from '../dto/journeyRecord.dto';
import { CheckJourneyDTO } from '../dto/journeyCheck.dto';
import { JourneyNotFoundException } from '../../filters/journey.exception';
import { UserNotFoundException } from 'src/filters/user.exception';

@Injectable()
export class JourneyService {
  constructor(
    @InjectModel(Journey.name) private journeyModel: Model<Journey>,
    @InjectModel(User.name) private userModel: Model<User>,
  ) {}
  async insertJourneyData(startJourneyDTO: StartJourneyDTO) {
    const journeyData: Journey = {
      ...startJourneyDTO,
      title: '',
      spots: [],
      coordinates: [startJourneyDTO.coordinate],
      endTime: '',
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
    return result;
  }
  async create(startJourneyDTO: StartJourneyDTO): Promise<Journey> {
    const createdJourneyData = await this.insertJourneyData(startJourneyDTO);
    const updateUserInfo = await this.pushJourneyIdToUser(
      createdJourneyData._id,
      startJourneyDTO.userId,
    );
    return createdJourneyData;
  }

  async end(endJourneyDTO: EndJourneyDTO) {
    const { journeyId, title, coordinate, endTime } = endJourneyDTO;
    const coordinateToAdd = Array.isArray(coordinate[0])
      ? coordinate
      : [coordinate];
    const updatedJourney = await this.journeyModel
      .findOneAndUpdate(
        { _id: journeyId },
        {
          $set: { title, endTime },
          $push: { coordinates: { $each: coordinateToAdd } },
        },
        { new: true },
      )
      .lean();

    if (!updatedJourney) {
      throw new JourneyNotFoundException();
    }
    return updatedJourney;
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
