import { Model } from 'mongoose';
import { Injectable } from '@nestjs/common';

import { InjectModel } from '@nestjs/mongoose';
import { Spot } from './spot.schema';
import { RecordSpotDTO } from './dto/recordSpot.dto';
import { Journey } from '../journey/journey.schema';
import * as AWS from 'aws-sdk';
import fs from 'fs';
const endpoint = 'https://kr.object.ncloudstorage.com';
const region = 'kr-standard';
const access_key = '194C0D972294FBAFCE35';
const secret_key = '1F6B29EFE66643E13693CE8D23AFD8897D8A1951';

@Injectable()
export class SpotService {
  constructor(
    @InjectModel(Spot.name) private spotModel: Model<Spot>,
    @InjectModel(Journey.name) private journeyModel: Model<Journey>,
  ) {}
  async uploadPhotoToStorage(photoData: Buffer): Promise<string> {
    const S3 = new AWS.S3({
      endpoint,
      region,
      credentials: {
        accessKeyId: access_key,
        secretAccessKey: secret_key,
      },
    });
    const key = `${Date.now()}`;
    const result = await S3.putObject({
      Bucket: 'music-spot-storage',
      Key: key,
      Body: photoData,
    }).promise();
    console.log(result);

    return `https://kr.object.ncloudstorage.com/music-spot-storage/${key}`;
  }
  async insertToSpot(spotData) {
    const createdSpotData = await new this.spotModel(spotData).save();
    const spotId = createdSpotData._id;
    await this.journeyModel.updateOne(
      { _id: spotData.journeyId },
      { $push: { spots: spotId } },
    );
    return createdSpotData;
  }
  async create(recordSpotDto: RecordSpotDTO) {
    const photoUrl = await this.uploadPhotoToStorage(recordSpotDto.photoData);
    return await this.insertToSpot({ ...recordSpotDto, photoUrl });
  }
}
