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
import * as turf from '@turf/turf';
import { LoadJourneyDTO } from '../dto/journeyLoad.dto';

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
      endTimestamp: '',
    };
    const createdJourneyData = new this.journeyModel(journeyData);
    return await createdJourneyData.save();
  }
  async pushJourneyIdToUser(journeyId, userEmail) {
    const result = await this.userModel
      .findOneAndUpdate(
        { email: userEmail },
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
      startJourneyDTO.email,
    );
    return createdJourneyData;
  }

  async end(endJourneyDTO: EndJourneyDTO) {
    const { journeyId, title, coordinate, endTimestamp } = endJourneyDTO;
    const coordinateToAdd = Array.isArray(coordinate[0])
      ? coordinate
      : [coordinate];
    const updatedJourney = await this.journeyModel
      .findOneAndUpdate(
        { _id: journeyId },
        {
          $set: { title, endTimestamp },
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
    return updatedJourney;
  }

  async checkJourney(checkJourneyDTO: CheckJourneyDTO) {
    const { userId, minCoordinate, maxCoordinate } = checkJourneyDTO;
    const user = await this.userModel.findById(userId).lean();

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
  async loadLastJourney(loadJourneyDTO: LoadJourneyDTO) {
    const { userId } = loadJourneyDTO;
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
    let journeyList = [];

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
