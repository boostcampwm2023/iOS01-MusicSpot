import { Test, TestingModule } from '@nestjs/testing';
import { JourneyService } from './journey.service';

import { UserService } from '../../user/serivce/user.service';
import * as fs from 'fs';
import { JourneyRepository } from '../repository/journey.repository';
import { UserRepository } from '../../user/repository/user.repository';
import { SpotRepository } from '../../spot/repository/spot.repository';
import { RecordSpotReqDTO, RecordSpotResDTO } from '../dto/spot/recordSpot.dto';
import { makePresignedUrl } from '../../common/s3/objectStorage';
import { PhotoRepository } from '../../photo/photo.repository';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Photo } from '../../photo/entity/photo.entity';
import { Journey } from '../entities/journey.entity';
import { User } from '../../user/entities/user.entity';
import { Spot } from '../../spot/entities/spot.v2.entity';

let service: JourneyService;
jest.mock('aws-sdk', () => {
  return {
    S3: jest.fn(() => ({
      putObject: jest.fn(() => ({
        promise: jest.fn().mockResolvedValue('fake'),
      })),
      getSignedUrl: jest.fn().mockResolvedValue('presigned url'),
    })),
  };
});

const mockPhotoRepository = {
  save: jest.fn(),
};
const mockSpotRepository = {
  save: jest.fn(),
};
beforeAll(async () => {
  const module: TestingModule = await Test.createTestingModule({
    providers: [
      JourneyService,
      UserService,
      // JourneyRepository,
      // UserRepository,
      // SpotRepository,
      {
        provide: getRepositoryToken(Photo),
        useValue: mockPhotoRepository,
      },
      {
        provide: getRepositoryToken(Journey),
        useValue: mockPhotoRepository,
      },
      {
        provide: getRepositoryToken(User),
        useValue: mockPhotoRepository,
      },
      {
        provide: getRepositoryToken(Spot),
        useValue: mockSpotRepository,
      },
      JourneyRepository,
    ],
  }).compile();
  service = module.get<JourneyService>(JourneyService);
});

describe('test', () => {
  it('spot 저장 테스트', async () => {
    // given
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
    const files = [
      {
        buffer: fs.readFileSync(`${__dirname}/test-image/test.png`),
      },
      { buffer: fs.readFileSync(`${__dirname}/test-image/test1.png`) },
    ];
    // when
    // 1. 이미지 s3 업로드 (key 반환)
    // savePhotoToS3(files, journeyId)
    const keys = await service.savePhotoToS3(files, journeyId);
    console.log(keys);
    expect(keys.length).toEqual(2);
    // const reuturnedData: RecordSpotResDTO = {
    //   journeyId: journeyId,
    //   ...recordSpotDto,
    //   photoUrls: keys.map((key) => makePresignedUrl(key)),
    // };
    // // 2. spot 저장(저장된 spot 반환)
    // // saveSpot(keys, dto)
    mockSpotRepository.save.mockResolvedValue({
      spotId: 2,
    });
    const result = await service.saveSpotDtoToSpot(
      keys,
      journeyId,
      recordSpotDto,
    );
    console.log(result);
    const { spotId } = result;
    expect(spotId).toEqual(2);

    mockPhotoRepository.save.mockResolvedValue([
      { spotId, photoKey: keys[0] },
      { spotId, photoKey: keys[1] },
    ]);

    const result2 = await service.savePhotoKeysToPhoto(result.spotId, keys);

    console.log(result2);
    expect(result2.length).toEqual(2);

    // then
  });

  it('photo 저장 테스트', async () => {
    const spotId = 20;
    const keys = ['20/315131', '20/313651365'];
    mockPhotoRepository.save.mockResolvedValue([
      { spotId: spotId, photoKey: keys[0], photoId: 0 },
      { spotId: spotId, photoKey: keys[1], photoId: 1 },
    ]);

    const result = await service.savePhotoKeysToPhoto(spotId, keys);

    expect(result.length).toEqual(2);
  });
});
