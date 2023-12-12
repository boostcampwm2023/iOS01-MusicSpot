import { Model } from 'mongoose';
import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Spot } from '../schema/spot.schema';
import { RecordSpotReqDTO, RecordSpotResDTO } from '../dto/recordSpot.dto';
import { Journey } from '../../journey/schema/journey.schema';
import {
  SpotNotFoundException,
  SpotRecordFail,
} from 'src/filters/spot.exception';
import {
  S3,
  endpoint,
  bucketName,
  makePresignedUrl,
} from '../../common/s3/objectStorage';
@Injectable()
export class SpotService {
  constructor(
    @InjectModel(Spot.name) private spotModel: Model<Spot>,
    @InjectModel(Journey.name) private journeyModel: Model<Journey>,
  ) {}
  async uploadPhotoToStorage(journeyId, file) {
    try {
      const key = `${journeyId}/${Date.now()}`;
      const result = await S3.putObject({
        Bucket: bucketName,
        Key: key,
        Body: file.buffer,
      }).promise();

      return key;
    } catch (err) {
      throw new SpotRecordFail();
    }
  }

  async insertToSpot(spotData) {
    const data = { ...spotData, coordinate: JSON.parse(spotData.coordinate) };
    const createdSpotData = await new this.spotModel(data).save();
    const { _id, coordinate } = createdSpotData;

    await this.journeyModel
      .findOneAndUpdate(
        { _id: spotData.journeyId },
        { $push: { spots: _id, coordinates: coordinate } },
        { new: true },
      )
      .lean();
    return createdSpotData.toObject();
  }

  async create(file, recordSpotDto) {
    const photoKey = await this.uploadPhotoToStorage(
      recordSpotDto.journeyId,
      file,
    );
    const presignedUrl = makePresignedUrl(photoKey);
    const createdSpotData = await this.insertToSpot({
      ...recordSpotDto,
      photoKey,
    });
    const { journeyId, coordinate, timestamp } = createdSpotData;

    const returnData: RecordSpotResDTO = {
      journeyId,
      coordinate,
      timestamp,
      photoUrl: presignedUrl,
    };
    return returnData;
  }
  async getSpotImage(spotId: string) {
    const spot = await this.spotModel.findById(spotId).lean();
    if (!spot) {
      throw new SpotNotFoundException();
    }

    return spot.photoKey;
  }
}
