import { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import { Injectable } from '@nestjs/common';
import { StartJourneyDTO } from './dto/journeyStart.dto';
import { Journey } from './journey.schema';
import { User } from '../user/user.schema';

@Injectable()
export class JourneyService {
  constructor(
    @InjectModel(Journey.name) private journeyModel: Model<Journey>,
    @InjectModel(User.name) private userModel: Model<User>,
  ) {}
  async insertJourneyData(startJourneyDTO: StartJourneyDTO) {
    const journeyData = {
      ...startJourneyDTO,
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
}
