import { Test, TestingModule } from '@nestjs/testing';
import { JourneyController } from './journey.controller';

import { StartJourneyDTO } from '.././dto/journeyStart.dto';
import { JourneyService } from '../service/journey.service';
import mongoose from 'mongoose';
import { User, UserSchema } from '../../user/schema/user.schema';
import { Journey, JourneySchema } from '../schema/journey.schema';
import { getModelToken } from '@nestjs/mongoose';

describe('JourneyController', () => {
  let controller: JourneyController;
  let userModel;
  let journeyModel;

  beforeAll(async () => {
    mongoose.connect(
      `mongodb://${process.env.DB_HOST}:${process.env.DB_PORT}/${process.env.DB_NAME}`,
    );
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
