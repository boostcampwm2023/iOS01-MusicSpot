import { Model } from 'mongoose';
import { Injectable } from '@nestjs/common';

import { InjectModel } from '@nestjs/mongoose';
import { Spot } from './spot.schema';
import { RecordSpotDTO } from './dto/recordSpot.dto';
import { Journey } from '../journey/journey.schema';
import * as AWS from 'aws-sdk';

const endpoint = process.env.NCLOUD_ENDPOINT;
const region = process.env.NCLOUD_REGION;
const access_key = process.env.NCLOUD_ACCESS_KEY;
const secret_key = process.env.NCLOUD_SECRET_KEY;
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
