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
  let mockJourneyModel = {
    save: jest.fn(),
    updateOne: jest.fn(),
  };
  beforeAll(async () => {
    // mongoose.connect(
    //   `mongodb://${process.env.DB_HOST}:${process.env.DB_PORT}/${process.env.DB_NAME}`,
    // );
    // userModel = mongoose.model(User.name, UserSchema);
    // journeyModel = mongoose.model(Journey.name, JourneySchema);

    // const module: TestingModule = await Test.createTestingModule({
    //   providers: [
    //     JourneyService,
    //     UserService,
    //     {
    //       provide: getModelToken(Journey.name),
    //       useValue: journeyModel,
    //     },
    //     {
    //       provide: getModelToken(User.name),
    //       useValue: userModel,
    //     },
    //   ],
    // }).compile();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        JourneyService,
        UserService,
        {
          provide: getModelToken(Journey.name),
          useValue: mockJourneyModel,
        },
        {
          provide: getModelToken(User.name),
          useValue: userModel,
        },
      ],
    }).compile();
    service = module.get<JourneyService>(JourneyService);
  });

  it.skip('journey 시작 테스트', async () => {
    const coordinate = [37.675986, 126.776032];
    const timestamp = '2023-11-22T15:30:00.000+09:00';
    const email = 'test-email';

    const createJourneyData: StartJourneyDTO = {
      coordinate,
      timestamp,
      email,
    };

    const createdJourneyData =
      await service.insertJourneyData(createJourneyData);
    expect(coordinate).toEqual(createdJourneyData.coordinates[0]);
    expect(timestamp).toEqual(createdJourneyData.timestamp);
    expect(createdJourneyData.spots).toEqual([]);

    const updateUserInfo = await service.pushJourneyIdToUser(
      createdJourneyData._id,
      email,
    );
    // console.log(createdUserData);
    expect(updateUserInfo.modifiedCount).toEqual(1);
  });

  it('실시간 위치 기록 테스트', async () => {
    const coordinate = [37.675986, 126.776032];
    const journeyId = '655efda2fdc81cae36d20650';
    mockJourneyModel.updateOne.mockResolvedValue({
      acknowledged: true,
      modifiedCount: 1,
      upsertedId: null,
      upsertedCount: 0,
      matchedCount: 1,
    });
    const returnData = await service.pushCoordianteToJourney(
      journeyId,
      coordinate,
    );

    expect(returnData.modifiedCount).toEqual(1);
    // 위치와 여정 아이디를 받음
    // journey에 저장
  });
  afterAll(async () => {
    mongoose.connection.close();
  });
});
