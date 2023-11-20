import { Test, TestingModule } from '@nestjs/testing';
import { SpotsService } from './spots.service';
import mongoose from 'mongoose';
import { Spot, SpotSchema } from './spots.schema';
import { getModelToken } from '@nestjs/mongoose';

describe('SpotsService', () => {
  let service: SpotsService;
  let spotModel;
  beforeEach(async () => {
    mongoose.connect('mongodb://192.168.174.128:27017/musicspotDB');
    spotModel = mongoose.model(Spot.name, SpotSchema);
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SpotsService,
        {
          provide: getModelToken(Spot.name),
          useValue: spotModel,
        },
      ],
    }).compile();

    service = module.get<SpotsService>(SpotsService);
  });

  it('spot 삽입 테스트', async () => {
    console.log(await spotModel.find().exec());
    const prevData = (await spotModel.find().exec()).length;
    const data = {
      journalId: '65560b729f8c1cbb025ab722',
      coordinate: [10, 10],
      timestamp: '1시5분',
    };
    await service.create(data);
    console.log(prevData);
    const nextData = (await spotModel.find().exec()).length;
    expect(prevData + 1).toEqual(nextData);
  });

  afterAll(() => {
    mongoose.connection.close();
  });
});
