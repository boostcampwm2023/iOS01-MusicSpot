import { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import { Injectable } from '@nestjs/common';
import { StartJourneyDTO } from '../dto/journeyStart.dto';
import { Journey } from '../schema/journey.schema';

import { User } from '../../user/schema/user.schema';
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
    const journeyId = endJourneyDTO.journeyId;
    return await this.journeyModel
      .findOneAndUpdate(
        { _id: journeyId },
        {
          $set: { title: endJourneyDTO.title },
          $push: { coordinates: endJourneyDTO.coordinate },
        },
        { new: true },
      )
      .lean();
  }

  async pushCoordianteToJourney(recordJourneyDTO: RecordJourneyDTO) {
    const { journeyId, coordinate } = recordJourneyDTO;
    return await this.journeyModel
      .updateOne({ _id: journeyId }, { $push: { coordinates: coordinate } })
      .lean();
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
    let journeyList = [];
    for (let i = 0; i < journeys.length; i++) {
      let journey = await this.journeyModel.findById(journeys[i]).exec();
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
