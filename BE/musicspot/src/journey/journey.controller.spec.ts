import { Test, TestingModule } from '@nestjs/testing';
import { JourneyController } from './journey.controller';

import { StartJourneyDTO } from './dto/journeyStart.dto';
import { JourneyService } from './journey.service';
import mongoose from 'mongoose';
import { User, UserSchema } from '../user/user.schema';
import { Journey, JourneySchema } from './journey.schema';
import { getModelToken } from '@nestjs/mongoose';

describe('JourneyController', () => {
  let controller: JourneyController;
  let userModel;
  let journeyModel;

  beforeAll(async () => {
    mongoose.connect('mongodb://192.168.174.128:27017/musicspotDB');
    userModel = mongoose.model(User.name, UserSchema);
    journeyModel = mongoose.model(Journey.name, JourneySchema);
    const module: TestingModule = await Test.createTestingModule({
      controllers: [JourneyController],
      providers: [
        JourneyService,
        {
          provide: getModelToken(Journey.name),
          useValue: journeyModel,
        },
        {
          provide: getModelToken(User.name),
          useValue: userModel,
        },
      ],

    }).compile();

    controller = module.get<JourneyController>(JourneyController);
  });

  it('/POST journey 테스트', async () => {
    const coordinate = [37.675987, 126.776033];
    const timestamp = '2023-11-22T15:30:00.000+09:00';
    const email = 'test-email';

    const JourneyData: StartJourneyDTO = {
      coordinate,
      timestamp,
      email,
    };
    const createdJourneyData = await controller.create(JourneyData);
    expect(coordinate).toEqual(createdJourneyData.coordinates[0]);
    expect(timestamp).toEqual(createdJourneyData.timestamp);
    expect(createdJourneyData.spots).toEqual([]);
  });

  afterAll(async () => {
    mongoose.connection.close();

  });
});
