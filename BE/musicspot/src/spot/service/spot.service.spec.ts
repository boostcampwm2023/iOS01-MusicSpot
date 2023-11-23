import * as fs from 'fs';
import * as path from 'path';
import { Test, TestingModule } from '@nestjs/testing';
import { SpotService } from './spot.service';
import mongoose from 'mongoose';
import { Spot, SpotSchema } from './schema/spot.schema';
import { getModelToken } from '@nestjs/mongoose';

import { Journey, JourneySchema } from '../journey/schema/journey.schema';
import { ConfigBase } from 'aws-sdk/lib/config';
describe('SpotService', () => {
  let service: SpotService;
  let spotModel;
  let journeyModel;
  beforeAll(async () => {
    mongoose.connect('mongodb://192.168.174.128:27017/musicspotDB');
    spotModel = mongoose.model(Spot.name, SpotSchema);
    journeyModel = mongoose.model(Journey.name, JourneySchema);
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SpotService,
        {
          provide: getModelToken(Spot.name),
          useValue: spotModel,
        },
        { provide: getModelToken(Journey.name), useValue: journeyModel },
      ],
    }).compile();

    service = module.get<SpotService>(SpotService);
  });

  it('spot 삽입 테스트', async () => {
    const imagePath = path.join(__dirname, 'test/test.png');

    // 이미지 파일 동기적으로 읽기
    const imageBuffer = fs.readFileSync(imagePath);

    const journeyId = '655b6d6bfd9f60fc689789a6';
    const data = {
      journeyId,
      coordinate: [10, 10],
      timestamp: '1시50분',
      photo: imageBuffer,
    };
    const photoUrl = await service.uploadPhotoToStorage(data.photo);
    const createdSpotData = await service.insertToSpot({ ...data, photoUrl });
    expect(createdSpotData.journeyId).toEqual(journeyId);
  });

  afterAll(() => {
    mongoose.connection.close();
  });
});
