import { Model } from 'mongoose';
import { Injectable } from '@nestjs/common';

import { InjectModel } from '@nestjs/mongoose';
import { Spot } from './spot.schema';
import { RecordSpotDTO } from './dto/recordSpot.dto';
import { Journey } from 'src/journey/journey.schema';

@Injectable()
export class SpotService {
  constructor(
    @InjectModel(Spot.name) private spotModel: Model<Spot>,
    @InjectModel(Journey.name) private journeyModel: Model<Journey>,
  ) {}

  async create(recordSpotDTO: RecordSpotDTO): Promise<Spot> {
    const createdSpotData = await new this.spotModel(recordSpotDTO).save();
    const spotId = createdSpotData._id;
    await this.journeyModel.updateOne(
      { _id: recordSpotDTO.journeyId },
      { $push: { spots: spotId } },
    );
    return createdSpotData;
  }
}
