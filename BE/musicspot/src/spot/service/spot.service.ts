import { Injectable } from '@nestjs/common';
import { Spot } from '../entities/spot.entity';
import {
  SpotNotFoundException,
  SpotRecordFail,
} from 'src/filters/spot.exception';
import {
  S3,
  bucketName,
  makePresignedUrl,
} from '../../common/s3/objectStorage';

import {
  JourneyNotFoundException,
  coordinateNotCorrectException,
} from 'src/filters/journey.exception';
import {
  is1DArray,
  parseCoordinateFromDtoToGeo,
  parseCoordinateFromGeoToDto,
} from 'src/common/util/coordinate.util';
import { SpotRepository } from '../repository/spot.repository';
import { RecordSpotResDTO } from '../dto/recordSpot.dto';
import { JourneyRepository } from 'src/journey/repository/journey.repository';
import {
  RecordSpotReqDTOV2,
  RecordSpotResDTOV2,
} from '../dto/v2/recordSpot.v2.dto';
import {
  isPointString,
  parseCoordinateFromDtoToGeoV2,
  parseCoordinateFromGeoToDtoV2,
} from '../../common/util/coordinate.v2.util';
import { InjectRepository } from '@nestjs/typeorm';
import { Journey } from '../../journey/entities/journey.entity';
import { Repository } from 'typeorm';
import { Photo } from '../../photo/entity/photo.entity';

@Injectable()
export class SpotService {
  constructor(
    // private spotRepository: SpotRepository,
    // private journeyRepository: JourneyRepository,
    @InjectRepository(Journey) private journeyRepository: Repository<Journey>,
    @InjectRepository(Spot) private spotRepository: Repository<Spot>,
    @InjectRepository(Photo) private photoRepository: Repository<Photo>,
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
  async uploadPhotoToStorageV2(journeyId, files) {
    const keys: string[] = [];
    try {
      const promises = files.map(async (file, idx) => {
        const key = `${journeyId}/${Date.now()}${idx}`;
        keys.push(key);
        const result = await S3.putObject({
          Bucket: bucketName,
          Key: key,
          Body: file.buffer,
        }).promise();
      });
      await Promise.all(promises);
      // return key;
      return keys;
    } catch (err) {
      throw new SpotRecordFail();
    }
  }
  async insertToSpotV2(spotData) {
    const data = {
      ...spotData,
      journeyId: Number(spotData.journeyId),
    };

    return await this.spotRepository.save(data);
  }
  async insertToSpot(spotData) {
    const point = `POINT(${parseCoordinateFromDtoToGeo(spotData.coordinate)})`;
    const data = {
      ...spotData,
      journeyId: Number(spotData.journeyId),
      coordinate: point,
    };

    return await this.spotRepository.save(data);
  }

  async updateCoordinatesToJourney(journeyId, coordinate) {
    const parsedCoordinate = parseCoordinateFromDtoToGeo(coordinate);
    const originalJourney = await this.journeyRepository.findOne({
      where: { journeyId },
    });
    const lineStringLen = 'LINESTRING('.length;

    if (!originalJourney) {
      throw new JourneyNotFoundException();
    }
    originalJourney.coordinates = `LINESTRING(${originalJourney.coordinates.slice(
      lineStringLen,
      -1,
    )}, ${parsedCoordinate})`;

    return await this.journeyRepository.save(originalJourney);
  }

  async createV2(files, recordSpotDto) {
    const { coordinate } = recordSpotDto;
    if (!isPointString(coordinate)) {
      throw new coordinateNotCorrectException();
    }
    const keys: string[] = await this.uploadPhotoToStorageV2(
      recordSpotDto.journeyId,
      files,
    );

    // const presignedUrls:string[] = keys.map(key=> makePresignedUrl(key))

    // const createdSpotData = await this.insertToSpotV2({
    //   ...recordSpotDto,
    //   photoKey,
    //   coordinate: parseCoordinateFromDtoToGeoV2(coordinate),
    // });
    //
    // // const returnData: RecordSpotResDTOV2 = {
    ``; // //   journeyId: createdSpotData.journeyId,
    // //   coordinate: parseCoordinateFromGeoToDtoV2(createdSpotData.coordinate),
    // //   timestamp: createdSpotData.timestamp,
    // //   photoUrl: presignedUrl,
    // // };
    //
    // return returnData;
  }
  async create(file, recordSpotDto) {
    let parsedCoordinate;
    try {
      parsedCoordinate = JSON.parse(recordSpotDto.coordinate);
    } catch (err) {
      throw new coordinateNotCorrectException();
    }
    if (!is1DArray(parsedCoordinate)) {
      throw new coordinateNotCorrectException();
    }

    const photoKey = await this.uploadPhotoToStorage(
      recordSpotDto.journeyId,
      file,
    );
    const presignedUrl = makePresignedUrl(photoKey);

    const createdSpotData = await this.insertToSpot({
      ...recordSpotDto,
      photoKey,
      coordinate: parsedCoordinate,
    });
    const updatedJourneyData = await this.updateCoordinatesToJourney(
      recordSpotDto.journeyId,
      parsedCoordinate,
    );

    const returnData: RecordSpotResDTO = {
      journeyId: createdSpotData.journeyId,
      coordinate: parsedCoordinate,
      timestamp: createdSpotData.timestamp,
      photoUrl: presignedUrl,
    };

    return returnData;
  }

  async getSpotImage(spotId: number) {
    const spot = await this.spotRepository.findOne({ where: { spotId } });
    if (!spot) {
      throw new SpotNotFoundException();
    }

    return spot.photoKey;
  }

  async savePhotoToS3(files, spotId: number) {
    const keys: string[] = [];
    const promises = files.map(async (file, idx) => {
      const key: string = `${spotId}/${Date.now()}${idx}`;
      keys.push(key);
      const reusult = await S3.putObject({
        Bucket: bucketName,
        Key: key,
        Body: file.buffer,
      }).promise();
    });
    await Promise.all(promises);
    return keys;
  }
  async savePhotoKeysToPhoto(spotId, keys) {
    const data = keys.map((key) => {
      return {
        spotId,
        photoKey: key,
      };
    });
    return await this.photoRepository.save(data);
  }

  async savePhoto(files, spotId) {
    const keys = await this.savePhotoToS3(files, spotId);
    return await this.savePhotoKeysToPhoto(spotId, keys);
  }
}
