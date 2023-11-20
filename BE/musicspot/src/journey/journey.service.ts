import { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import { Injectable } from '@nestjs/common';
import { StartJourneyDTO } from './dto/journeyStart.dto';
import { Journey } from './journey.schema';
import { UserService } from '../user/user.service';
import { User } from 'src/user/user.schema';

@Injectable()
export class JourneyService {
  constructor(
    @InjectModel(Journey.name) private journeyModel: Model<Journey>,
    @InjectModel(User.name) private personModel: Model<User>,
    private userService: UserService,
  ) {}

  async create(startJourneyDTO: StartJourneyDTO): Promise<Journey> {
    const journeyData = {
      ...startJourneyDTO,
      spots: [],
      coordinates: [startJourneyDTO.coordinate],
    };
    const createdJourney = new this.journeyModel(journeyData);
    const returnData = await createdJourney.save();
    const journeyId = returnData._id;
    this.userService.appendJourneyIdToUser(startJourneyDTO.email, journeyId);
    return returnData;
  }
}
