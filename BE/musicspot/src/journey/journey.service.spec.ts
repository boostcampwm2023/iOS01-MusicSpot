import { Test, TestingModule } from '@nestjs/testing';
import { JourneyService } from './journey.service';
import mongoose from 'mongoose';
import { User, UserSchema } from '../user/user.schema';
import { Journey, JourneySchema } from './journey.schema';
import { getModelToken } from '@nestjs/mongoose';
import { StartJourneyDTO } from './dto/journeyStart.dto';
import { UserService } from '../user/user.service';

describe('JourneysService', () => {
  let service: JourneyService;
  let userModel;
  let journeyModel;
  beforeEach(async () => {
    mongoose.connect('mongodb://192.168.174.128:27017/musicspotDB');
    userModel = mongoose.model(User.name, UserSchema);
    journeyModel = mongoose.model(Journey.name, JourneySchema);

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        JourneyService,
        UserService,
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

    service = module.get<JourneyService>(JourneyService);
  });

  it('journey 시작 테스트', async () => {
    const insertData: StartJourneyDTO = {
      title: 'test2',
      coordinate: [100, 100],
      timestamp: 'time test code',
      email: 'test',
    };
    const dataLength = (await journeyModel.find().exec()).length;
    const journeyLength = (await userModel.find({ email: 'test' }).exec())[0]
      .journeys.length;

    await service.create(insertData);
    const nextDataLength = (await journeyModel.find().exec()).length;
    const nextJourneyLength = (
      await userModel.find({ email: 'test' }).exec()
    )[0].journeys.length;

    expect(dataLength + 1).toEqual(nextDataLength);
    expect(journeyLength + 1).toEqual(nextJourneyLength);
  });

  afterAll(async () => {
    mongoose.connection.close();
  });
});
