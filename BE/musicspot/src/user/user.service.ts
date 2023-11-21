import { Injectable } from '@nestjs/common';
import { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import { User } from './user.schema';
@Injectable()
export class UserService {
  constructor(@InjectModel(User.name) private userModel: Model<User>) {}
  async appendJourneyIdToUser(
    userEmail: string,
    journeyId: object,
  ): Promise<any> {
    return this.userModel.updateOne(
      { email: userEmail },
      { $push: { journeys: journeyId } },
    );
  }
}
