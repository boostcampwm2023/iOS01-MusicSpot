import { Injectable, Version } from '@nestjs/common';
import { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
// import { User } from '../schema/user.schema';
import { UUID } from 'crypto';
import { CreateUserDTO } from '../dto/createUser.dto';
import {
  UserAlreadyExistException,
  UserNotFoundException,
} from '../../filters/user.exception';
import { UserRepository } from '../repository/user.repository';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from '../entities/user.entity';
import { Repository } from 'typeorm';
import { Journey } from '../../journey/entities/journey.entity';
import { JourneyV2 } from '../../journey/entities/journey.v2.entity';
import {
  StartJourneyRequestDTOV2,
  StartJourneyResponseDTOV2,
} from '../dto/startJourney.dto';
import {
  isPointString,
  parseCoordinateFromGeoToDtoV2,
  parseCoordinatesFromGeoToDtoV2,
} from '../../common/util/coordinate.v2.util';
import { coordinateNotCorrectException } from '../../filters/journey.exception';
import { makePresignedUrl } from '../../common/s3/objectStorage';
// @Injectable()
// export class UserService {
//   constructor(@InjectModel(User.name) private userModel: Model<User>) {}
//   async create(createUserDto: CreateUserDTO): Promise<User> {
//     const userData = {
//       ...createUserDto,
//       journeys: [],
//     };

//     // 유저 id 중복 시 예외 처리
//     if (await this.isExist(createUserDto.userId)) {
//       throw new UserAlreadyExistException();
//     }
//     const createdUser = new this.userModel(userData);
//     return await createdUser.save();
//   }

//   async isExist(userId: UUID) {
//     return this.userModel.exists({ userId });
//   }
//   // async appendJourneyIdToUser(
//   //   userEmail: string,
//   //   journeyId: object,
//   // ): Promise<any> {
//   //   return this.userModel.updateOne(
//   //     { email: userEmail },
//   //     { $push: { journeys: journeyId } },
//   //   );
//   // }
// }

@Injectable()
export class UserService {
  // constructor(private userRepository: UserRepository){}
  constructor(
    @InjectRepository(User) private userRepository: Repository<User>,
    @InjectRepository(JourneyV2)
    private journeyRepositoryV2: Repository<JourneyV2>,
  ) {}
  async create(
    createUserDto: CreateUserDTO,
  ): Promise<CreateUserDTO | undefined> {
    const { userId } = createUserDto;
    if (await this.userRepository.findOne({ where: { userId } })) {
      throw new UserAlreadyExistException();
    }
    return await this.userRepository.save(createUserDto);
  }

  async startJourney(userId, startJourneyDto: StartJourneyRequestDTOV2) {
    if (!(await this.userRepository.findOne({ where: { userId } }))) {
      throw new UserNotFoundException();
    }

    const journeyData = {
      userId,
      ...startJourneyDto,
    };
    return await this.journeyRepositoryV2.save(journeyData);
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
}
