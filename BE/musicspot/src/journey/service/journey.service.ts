import { Injectable } from '@nestjs/common';
import {
  StartJourneyReqDTO,
  StartJourneyResDTO,
} from '../dto/journeyStart/journeyStart.dto';
import {
  JourneyNotFoundException,
  coordinateNotCorrectException,
} from '../../filters/journey.exception';
import {
  EndJourneyReqDTO,
  EndJourneyResDTO,
} from '../dto/journeyEnd/journeyEnd.dto';
import {
  RecordJourneyReqDTO,
  RecordJourneyResDTO,
} from '../dto/journeyRecord/journeyRecord.dto';
import {
  is1DArray,
  parseCoordinateFromGeoToDto,
  parseCoordinatesFromGeoToDto,
} from '../../common/util/coordinate.util';
import { DeleteJourneyReqDTO } from '../dto/journeyDelete.dto';

import { Journey } from '../entities/journey.entity';
import {
  bucketName,
  makePresignedUrl,
  S3,
} from '../../common/s3/objectStorage';
import {
  StartJourneyReqDTOV2,
  StartJourneyResDTOV2,
} from '../dto/v2/startJourney.v2.dto';
import { EndJourneyReqDTOV2 } from '../dto/v2/endJourney.v2.dto';
import {
  isPointString,
  parseCoordinateFromDtoToGeoV2,
  parseCoordinateFromGeoToDtoV2,
  parseCoordinatesFromGeoToDtoV2,
} from '../../common/util/coordinate.v2.util';
import { UserNotFoundException } from '../../filters/user.exception';
import { Photo } from '../../photo/entity/photo.entity';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { Spot } from '../../spot/entities/spot.entity';
import { User } from '../../user/entities/user.entity';
import { SpotV2 } from '../../spot/entities/spot.v2.entity';
import { JourneyV2 } from '../entities/journey.v2.entity';

@Injectable()
export class JourneyService {
  constructor(
    @InjectRepository(Journey) private journeyRepository: Repository<Journey>,
    @InjectRepository(Spot) private spotRepository: Repository<Spot>,
    @InjectRepository(User) private userRepository: Repository<User>,
    @InjectRepository(Photo) private photoRepository: Repository<Photo>,
    @InjectRepository(SpotV2) private spotRepositoryV2: Repository<SpotV2>,
    @InjectRepository(JourneyV2)
    private journeyRepositoryV2: Repository<JourneyV2>,
  ) {}

  async insertJourneyData(startJourneyDTO: StartJourneyReqDTO) {
    const startPoint = startJourneyDTO.coordinate.join(' ');
    const lineStringOfCoordinates = `LINESTRING(${startPoint}, ${startPoint})`;

    const returnedData = await this.journeyRepository.save({
      ...startJourneyDTO,
      coordinates: lineStringOfCoordinates,
    });

    const [parsedCoordinate] = parseCoordinatesFromGeoToDto(
      returnedData.coordinates,
    );

    const returnData: StartJourneyResDTO = {
      journeyId: returnedData.journeyId,
      coordinate: parsedCoordinate,
      startTimestamp: returnedData.startTimestamp,
    };

    return returnData;
  }

  async insertJourneyDataV2(startJourneyDTO: StartJourneyReqDTOV2) {
    const returnedData = await this.journeyRepositoryV2.save(startJourneyDTO);

    const returnData: StartJourneyResDTOV2 = {
      journeyId: returnedData.journeyId,
      startTimestamp: returnedData.startTimestamp,
    };

    return returnData;
  }

  async end(endJourneyDTO: EndJourneyReqDTO) {
    const { coordinates, journeyId, song, title, endTimestamp } = endJourneyDTO;
    const coordinatesLen = coordinates.length;
    const originData = await this.journeyRepository.findOne({
      where: { journeyId },
    });
    if (!originData) {
      throw new JourneyNotFoundException();
    }

    const originCoordinates = originData.coordinates;
    const newCoordinates = (originData.coordinates =
      originCoordinates.slice(0, -1) +
      ',' +
      endJourneyDTO.coordinates
        .map((item) => `${item[0]} ${item[1]}`)
        .join(',') +
      ')');
    const newJourneyData = {
      ...originData,
      ...endJourneyDTO,
      song: JSON.stringify(song),
      coordinates: newCoordinates,
    };

    const returnedDate = await this.journeyRepository.save(newJourneyData);

    const parsedCoordinates = parseCoordinatesFromGeoToDto(
      returnedDate.coordinates,
    );
    const returnData: EndJourneyResDTO = {
      journeyId: returnedDate.journeyId,
      coordinates: parsedCoordinates.slice(
        parsedCoordinates.length - coordinatesLen,
      ),
      endTimestamp: returnedDate.endTimestamp,
      numberOfCoordinates: parsedCoordinates.length,
      song: JSON.parse(returnedDate.song),
    };

    return returnData;
  }
  async endV2(journeyId, endJourneyDTO: EndJourneyReqDTOV2) {
    const { coordinates, song } = endJourneyDTO;
    const originalData = await this.journeyRepositoryV2.findOne({
      where: { journeyId },
    });
    if (!originalData) {
      throw new JourneyNotFoundException();
    }

    const newCoordinates = `LINESTRING(${coordinates})`;
    const newJourneyData = {
      journeyId,
      ...originalData,
      ...endJourneyDTO,
      song: JSON.stringify(song),
      coordinates: newCoordinates,
    };

    const returnedDate = await this.journeyRepositoryV2.save(newJourneyData);

    const parsedCoordinates = parseCoordinatesFromGeoToDtoV2(
      returnedDate.coordinates,
    );
    const returnData = {
      journeyId: returnedDate.journeyId,
      coordinates: parsedCoordinates,
      endTimestamp: returnedDate.endTimestamp,
      numberOfCoordinates: parsedCoordinates.split(',').length,
      song: JSON.parse(returnedDate.song),
    };

    return returnData;
  }
  async pushCoordianteToJourney(recordJourneyDTO: RecordJourneyReqDTO) {
    const { journeyId, coordinates } = recordJourneyDTO;
    const coordinateLen = coordinates.length;
    const originData = await this.journeyRepository.findOne({
      where: { journeyId },
    });
    if (!originData) {
      throw new JourneyNotFoundException();
    }
    const originCoordinates = originData.coordinates;

    originData.coordinates =
      originCoordinates.slice(0, -1) +
      ',' +
      recordJourneyDTO.coordinates
        .map((item) => `${item[0]} ${item[1]}`)
        .join(',') +
      ')';
    const returnedData = await this.journeyRepository.save(originData);

    const updatedCoordinate = parseCoordinatesFromGeoToDto(
      returnedData.coordinates,
    );
    const len = updatedCoordinate.length;

    return { coordinates: updatedCoordinate.slice(len - coordinateLen) };
  }

  async getJourneyByCoordinationRangeV2(checkJourneyDTO) {
    const { userId, minCoordinate, maxCoordinate } = checkJourneyDTO;
    if (!(await this.userRepository.findOne({ where: { userId } }))) {
      throw new UserNotFoundException();
    }

    if (!(isPointString(minCoordinate) && isPointString(maxCoordinate))) {
      throw new coordinateNotCorrectException();
    }

    const [xMinCoordinate, yMinCoordinate] = minCoordinate
      .split(' ')
      .map((str) => Number(str));
    const [xMaxCoordinate, yMaxCoordinate] = maxCoordinate
      .split(' ')
      .map((str) => Number(str));
    console.log(xMinCoordinate, yMinCoordinate, xMaxCoordinate, yMaxCoordinate);
    const coordinatesRange = {
      xMinCoordinate,
      yMinCoordinate,
      xMaxCoordinate,
      yMaxCoordinate,
    };
    const returnedData = await this.journeyRepositoryV2
      .createQueryBuilder('journey')
      .leftJoinAndSelect('journey.spots', 'spot')
      .leftJoinAndSelect('spot.photos', 'photo')
      .where(
        `st_within(coordinates, ST_PolygonFromText('POLYGON((:xMinCoordinate :yMinCoordinate, :xMaxCoordinate :yMinCoordinate, :xMaxCoordinate :yMaxCoordinate, :xMinCoordinate :yMaxCoordinate, :xMinCoordinate :yMinCoordinate))'))`,
        coordinatesRange,
      )
      .where('userId = :userId', { userId })
      .getMany();
    return returnedData.map((data) => {
      return this.parseJourneyFromEntityToDtoV2(data);
    });
  }
  async getJourneyByCoordinationRange(checkJourneyDTO) {
    let { userId, minCoordinate, maxCoordinate } = checkJourneyDTO;
    if (!(Array.isArray(minCoordinate) && Array.isArray(maxCoordinate))) {
      throw new coordinateNotCorrectException();
    }

    minCoordinate = minCoordinate.map((item) => Number(item));
    maxCoordinate = maxCoordinate.map((item) => Number(item));

    if (!(is1DArray(minCoordinate) && is1DArray(maxCoordinate))) {
      throw new coordinateNotCorrectException();
    }
    const coordinatesRange = {
      xMinCoordinate: minCoordinate[0],
      yMinCoordinate: minCoordinate[1],
      xMaxCoordinate: maxCoordinate[0],
      yMaxCoordinate: maxCoordinate[1],
    };
    const returnedData = await this.journeyRepository.manager
      .createQueryBuilder(Journey, 'journey')
      .leftJoinAndSelect('journey.spots', 'spot')
      .where(
        `st_within(coordinates, ST_PolygonFromText('POLYGON((:xMinCoordinate :yMinCoordinate, :xMaxCoordinate :yMinCoordinate, :xMaxCoordinate :yMaxCoordinate, :xMinCoordinate :yMaxCoordinate, :xMinCoordinate :yMinCoordinate))'))`,
        coordinatesRange,
      )
      .where('userId = :userId', { userId })
      .getMany();

    return returnedData.map((data) => {
      return this.parseJourneyFromEntityToDto(data);
    });
  }
  async getLastJourneyByUserIdV2(userId) {
    const journeys = await this.journeyRepositoryV2.manager
      .createQueryBuilder(Journey, 'journey')
      .where({ userId })
      .leftJoinAndSelect('journey.spots', 'spot')
      .getMany();

    if (!journeys) {
      return {
        journey: null,
        isRecording: false,
      };
    }

    const journeyLen = journeys.length;
    const lastJourneyData = journeys[journeyLen - 1];

    if (lastJourneyData.title) {
      return { journey: null, isRecording: false };
    }

    return {
      journey: lastJourneyData,
      isRecording: true,
    };
  }
  async getLastJourneyByUserId(userId) {
    const journeys = await this.journeyRepository.manager
      .createQueryBuilder(Journey, 'journey')
      .where({ userId })
      .leftJoinAndSelect('journey.spots', 'spot')
      .getMany();

    if (!journeys) {
      return {
        journey: null,
        isRecording: false,
      };
    }

    const journeyLen = journeys.length;
    const lastJourneyData = journeys[journeyLen - 1];

    if (lastJourneyData.title) {
      return { journey: null, isRecording: false };
    }

    return {
      journey: this.parseJourneyFromEntityToDto(lastJourneyData),
      isRecording: true,
    };
  }
  async getJourneyByIdV2(journeyId) {
    const returnedData = await this.journeyRepositoryV2.findOne({
      where: { journeyId: journeyId },
      relations: ['spots', 'spots.photos'],
    });
    return this.parseJourneyFromEntityToDtoV2(returnedData);
  }
  async getJourneyById(journeyId) {
    const returnedData = await this.journeyRepository.manager
      .createQueryBuilder(Journey, 'journey')
      .where({ journeyId })
      .leftJoinAndSelect('journey.spots', 'spot')
      .getOne();
    return this.parseJourneyFromEntityToDto(returnedData);
  }
  parseJourneyFromEntityToDtoV2(journey) {
    const {
      journeyId,
      coordinates,
      startTimestamp,
      endTimestamp,
      song,
      title,
      spots,
    } = journey;
    return {
      journeyId,
      coordinates: parseCoordinatesFromGeoToDtoV2(coordinates),
      title,
      journeyMetadata: {
        startTimestamp,
        endTimestamp,
      },
      song: JSON.parse(song),
      spots: spots.map((spot) => {
        return {
          ...spot,
          coordinate: parseCoordinateFromGeoToDtoV2(spot.coordinate),
          spotSong: JSON.parse(spot.spotSong),
          photos: spot.photos.map((photo) => {
            return {
              ...photo,
              photoUrl: makePresignedUrl(photo.photoKey),
            };
          }),
        };
      }),
    };
  }
  parseJourneyFromEntityToDto(journey) {
    const {
      journeyId,
      coordinates,
      startTimestamp,
      endTimestamp,
      song,
      title,
      spots,
    } = journey;
    return {
      journeyId,
      coordinates: parseCoordinatesFromGeoToDto(coordinates),
      title,
      journeyMetadata: {
        startTimestamp,
        endTimestamp,
      },
      song: JSON.parse(song),
      spots: spots.map((spot) => {
        return {
          ...spot,
          coordinate: parseCoordinateFromGeoToDto(spot.coordinate),
          photoUrl: makePresignedUrl(spot.photoKey),
        };
      }),
    };
  }

  async deleteJourneyById(deletedJourneyDto: DeleteJourneyReqDTO) {
    const { journeyId } = deletedJourneyDto;
    return await this.journeyRepository.delete({ journeyId });
  }

  async savePhotoToS3(files, spotId) {
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

  async saveSpotDtoToSpot(journeyId, recordSpotDto) {
    try {
      const data = {
        ...recordSpotDto,
        journeyId: Number(journeyId),
        coordinate: parseCoordinateFromDtoToGeoV2(recordSpotDto.coordinate),
      };

      return await this.spotRepositoryV2.save(data);
    } catch (err) {
      console.log(err);
    }
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
  parseToSaveSpotResDtoFormat(spotResult, photoResult): RecordJourneyResDTO {
    return {
      spotId: spotResult.spotId,
      ...spotResult,
      spotSong: JSON.parse(spotResult.spotSong),
      photos: photoResult.map((result) => {
        return {
          photoId: result.photoId,
          photoUrl: makePresignedUrl(result.photoKey),
        };
      }),
    };
  }

  async saveSpot(files, journeyId, recordSpotDto) {
    const saveSpotResult = await this.saveSpotDtoToSpot(
      journeyId,
      recordSpotDto,
    );
    const keys: string[] = await this.savePhotoToS3(
      files,
      saveSpotResult.spotId,
    );
    const photoSaveReuslt = await this.savePhotoKeysToPhoto(
      saveSpotResult.spotId,
      keys,
    );

    return this.parseToSaveSpotResDtoFormat(saveSpotResult, photoSaveReuslt);
  }
  async deleteJourney(journeyId: number){
    return this.journeyRepositoryV2.delete(journeyId);
  }

}
