import { Model } from 'mongoose';
import { Injectable } from '@nestjs/common';

import { InjectModel } from '@nestjs/mongoose';
import { Spot } from '../schema/spot.schema';
import { RecordSpotDTO } from '../dto/recordSpot.dto';
import { Journey } from '../../journey/schema/journey.schema';
import * as AWS from 'aws-sdk';

const endpoint = process.env.NCLOUD_ENDPOINT;
const region = process.env.NCLOUD_REGION;
const accessKey = process.env.NCLOUD_ACCESS_KEY;
const secretKey = process.env.NCLOUD_SECRET_KEY;
const bucketName = process.env.BUCKET_NAME;

@Injectable()
export class SpotService {
  constructor(
    @InjectModel(Spot.name) private spotModel: Model<Spot>,
    @InjectModel(Journey.name) private journeyModel: Model<Journey>,
  ) {}
  async uploadPhotoToStorage(file): Promise<string> {
    const S3 = new AWS.S3({
      endpoint,
      region,
      credentials: {
        accessKeyId: accessKey,
        secretAccessKey: secretKey,
      },
    });
    const key = `${Date.now()}`;
    const result = await S3.putObject({
      Bucket: bucketName,
      Key: key,
      Body: file.buffer,
    }).promise();
    console.log(result);
    return `${endpoint}/${bucketName}/${key}`;
  }
  async insertToSpot(spotData) {
    const data = { ...spotData, coordinate: JSON.parse(spotData.coordinate) };
    const createdSpotData = await new this.spotModel(data).save();
    const spotId = createdSpotData._id;
    await this.journeyModel.findOneAndUpdate(
      { _id: spotData.journeyId },
      { $push: { spots: spotId } },
      { new: true },
    );
    return createdSpotData;
  }

  async create(file, recordSpotDto: RecordSpotDTO) {
    const photoUrl = await this.uploadPhotoToStorage(file);
    return await this.insertToSpot({ ...recordSpotDto, photoUrl });
  }
}
