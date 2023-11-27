import { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import { Injectable } from '@nestjs/common';
import { StartJourneyDTO } from '../dto/journeyStart.dto';
import { Journey } from '../schema/journey.schema';

import { User } from '../../user/schema/user.schema';
import { UserService } from '../../user/serivce/user.service';
import { EndJourneyDTO } from '../dto/journeyEnd.dto';
import { RecordJourneyDTO } from '../dto/journeyRecord.dto';
import { CheckJourneyDTO } from '../dto/journeyCheck.dto';

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
    };
    const createdJourneyData = new this.journeyModel(journeyData);
    return await createdJourneyData.save();
  }
  async pushJourneyIdToUser(journeyId, userEmail) {
    return await this.userModel.updateOne(
      { email: userEmail },
      { $push: { journeys: journeyId } },
    );
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
    const journeyId = endJourneyDTO._id;
    const journey = await this.journeyModel.findById(journeyId).exec();
    //check 참 조건인지 확인
    return journey.coordinates.length;
  }

  async pushCoordianteToJourney(recordJourneyDTO: RecordJourneyDTO) {
    const { journeyId, coordinate } = recordJourneyDTO;
    return await this.journeyModel.updateOne(
      { _id: journeyId },
      { $push: { coordinates: coordinate } },
    );
  }

  async checkJourney(checkJourneyDTO: CheckJourneyDTO) {
    const { userId, minCoordinate, maxCoordinate } = checkJourneyDTO;
    const user = await this.userModel.findById(userId).exec();
    const journeys = user.journeys;
    const journeyList = await this.findMinMaxCoordinates(
      journeys,
      minCoordinate,
      maxCoordinate,
    );
    return journeyList;
  }
  async findMinMaxCoordinates(journeys, minCoordinate, maxCoordinate) {
    let minCoordinates = [];
    let maxCoordinates = [];
    let journeyList = [];
    for (let i = 0; i < journeys.length; i++) {
      let journey = await this.journeyModel.findById(journeys[i]).exec();
      let minX = Infinity;
      let minY = Infinity;
      let maxX = -Infinity;
      let maxY = -Infinity;
      journey.coordinates.forEach(([x, y]) => {
        minX = Math.min(minX, x);
        minY = Math.min(minY, y);
        maxX = Math.max(maxX, x);
        maxY = Math.max(maxY, y);
      });
      if (
        minX > minCoordinate[0] &&
        minY > minCoordinate[1] &&
        maxX < maxCoordinate[0] &&
        maxY < maxCoordinate[1]
      ) {
        journeyList.push(journey.coordinates);
      }
    }
    return journeyList;
  }
}
