import { Model } from 'mongoose';
import { Injectable } from '@nestjs/common';

import { InjectModel } from '@nestjs/mongoose';
import { Spot } from './spots.schema';
import { RecordSpotDTO } from './dto/recordSpot.dto';

@Injectable()
export class SpotsService {
  constructor(@InjectModel(Spot.name) private spotModel: Model<Spot>) {}

  async create(recordSpotDTO: RecordSpotDTO): Promise<Spot> {
    return new this.spotModel(recordSpotDTO).save();
  }
}
