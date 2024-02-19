import { Test, TestingModule } from '@nestjs/testing';
import { JourneyService } from './journey.service';
import { UserService } from '../../user/serivce/user.service';
import { JourneyRepository } from '../repository/journey.repository';
import { UserRepository } from '../../user/repository/user.repository';
import { SpotRepository } from '../../spot/repository/spot.repository';
import { PhotoRepository } from '../../photo/photo.repository';
import { getRepositoryToken, TypeOrmModule } from '@nestjs/typeorm';
import { User } from '../../user/entities/user.entity';
import { Journey } from '../entities/journey.entity';
import { Spot } from '../../spot/entities/spot.v2.entity';
import { Photo } from '../../photo/entity/photo.entity';
import { Repository } from 'typeorm';
import * as dotenv from 'dotenv';
import { RecordSpotReqDTO } from '../dto/spot/recordSpot.dto';
import { parseCoordinateFromDtoToGeoV2 } from '../../common/util/coordinate.v2.util';

dotenv.config();
let journeyRepository;
let spotRepository;
let photoRepository;
beforeAll(async () => {
  const module: TestingModule = await Test.createTestingModule({
    providers: [],
    imports: [
      TypeOrmModule.forRoot({
        type: 'mysql',
        host: process.env.DB_HOST,
        port: Number(process.env.DB_PORT),
        username: process.env.DB_USERNAME,
        password: process.env.DB_PASSWORD,
        database: process.env.DB_NAME,
        entities: [User, Journey, Spot, Photo],
        synchronize: false,
        legacySpatialSupport: false,
      }),
      TypeOrmModule.forFeature([Journey, Spot, Photo]),
    ],
  }).compile();

  journeyRepository = module.get(getRepositoryToken(Journey));
  spotRepository = module.get(getRepositoryToken(Spot));
  photoRepository = module.get(getRepositoryToken(Photo));
});

describe('db 테스트', () => {
  it('save test', async () => {
    const journeyData = {
      title: 'test',
    };

    console.log(await journeyRepository.save(journeyData));
  });

  it('bulk insert 테스트', async () => {
    const spotId = 20;
    const keys = ['20/315131', '20/313651365'];

    console.log(
      await photoRepository.save(
        keys.map((key) => {
          return {
            spotId,
            photoKey: key,
          };
        }),
      ),
    );
  });

  it('spot save 테스트', async () => {
    const song = {
      id: '655efda2fdc81cae36d20650',
      name: 'super shy',
      artistName: 'newjeans',
      artwork: {
        width: 3000,
        height: 3000,
        url: 'https://is3-ssl.mzstatic.com/image/thumb/Music125/v4/0b/b2/52/0bb2524d-ecfc-1bae-9c1e-218c978d7072/Honeymoon_3K.jpg/{w}x{h}bb.jpg',
        bgColor: '3000',
      },
    };
    const journeyId = 20;
    const recordSpotDto: RecordSpotReqDTO = {
      coordinate: '37.555946 126.972384',
      timestamp: '2023-11-22T12:12:11Z',
      spotSong: song,
    };

    const data = {
      ...recordSpotDto,
      journeyId,
      spotSong: JSON.stringify(recordSpotDto.spotSong),
      coordinate: parseCoordinateFromDtoToGeoV2(recordSpotDto.coordinate),
      // photoKey: 'asd',
    };

    console.log(await spotRepository.save(data));
  });
});
