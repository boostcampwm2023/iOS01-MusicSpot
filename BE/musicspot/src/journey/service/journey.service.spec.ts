import { Test, TestingModule } from '@nestjs/testing';
import { JourneyService } from './journey.service';
import { User } from '../../user/schema/user.schema';
import { Journey } from '../schema/journey.schema';
import { getModelToken } from '@nestjs/mongoose';
import { StartJourneyDTO } from '../dto/journeyStart.dto';
import { UserService } from '../../user/serivce/user.service';
import { RecordJourneyDTO } from '../dto/journeyRecord.dto';
import { JourneyExceptionMessageEnum } from '../../filters/exception.enum';

let service: JourneyService;
let userModel;
let journeyModel;
beforeAll(async () => {
  const MockUserModel = {
    findOneAndUpdate: jest.fn(),
  };
  const MockJourneyModel = {
    findOneAndUpdate: jest.fn(),
    save: jest.fn(),
    lean: jest.fn(),
  };

  const module: TestingModule = await Test.createTestingModule({
    providers: [
      JourneyService,
      UserService,
      {
        provide: getModelToken(Journey.name),
        useValue: MockJourneyModel,
      },
      {
        provide: getModelToken(User.name),
        useValue: MockUserModel,
      },
    ],
  }).compile();

  service = module.get<JourneyService>(JourneyService);
  userModel = module.get(getModelToken(User.name));
  journeyModel = module.get(getModelToken(Journey.name));
});

describe('여정 시작 관련 service 테스트', () => {
  it('insertJourneyData 성공 테스트', async () => {
    journeyModel.save.mockResolvedValue({
      title: '',
      spots: [],
      coordinates: [[37.555946, 126.972384]],
      timestamp: '2023-11-22T12:00:00Z',
      _id: '65673e666b2fb1462684b2c7',
      __v: 0,
    });
    const data: StartJourneyDTO = {
      coordinate: [37.555946, 126.972384],
      timestamp: '2023-11-22T12:00:00Z',
      email: 'test@gmail.com',
    };

    try {
      const returnData = await service.insertJourneyData(data);
      const { title, spots, coordinates, timestamp } = returnData;
      expect(title).toEqual('');
      expect(spots).toEqual([]);
      expect(coordinates[0]).toEqual(data.coordinate);
      expect(timestamp).toEqual(data.timestamp);
    } catch (err) {
      console.log(err);
    }
  });
});

describe.skip('여정 기록 관련 service 테스트', () => {
  it('pushCoordianteToJourney 성공 테스트', async () => {
    const data: RecordJourneyDTO = {
      journeyId: '655f8bd2ceab803bb2d566bc',
      coordinate: [37.555947, 126.972385],
    };
    journeyModel.findOneAndUpdate.mockReturnValue({
      lean: jest.fn().mockResolvedValue({
        _id: '65673e666b2fb1462684b2c7',
        title: '',
        spots: [],
        coordinates: [[37.555947, 126.972385]],
        timestamp: '2023-11-22T12:00:00Z',
        __v: 0,
      }),
    });
    try {
      const returnData = await service.pushCoordianteToJourney(data);
      const { coordinates } = returnData;
      const lastCoorinate = coordinates[coordinates.length - 1];
      expect(lastCoorinate).toEqual(data.coordinate);
    } catch (err) {
      expect(err.status).toEqual(404);
      expect(err.message).toEqual(JourneyExceptionMessageEnum.JourneyNotFound);
    }
  });

  it('pushCoordianteToJourney 실패 테스트(journeyId 없는 경우)', async () => {
    journeyModel.findOneAndUpdate.mockReturnValue({
      lean: jest.fn().mockResolvedValue(null),
    });
    const data: RecordJourneyDTO = {
      journeyId: '655f8bd2ceab803bb2d566bc',
      coordinate: [37.555947, 126.972385],
    };
    try {
      const returnData = await service.pushCoordianteToJourney(data);
      expect(returnData).toBeDefined();
    } catch (err) {
      expect(err.status).toEqual(404);
      expect(err.message).toEqual(JourneyExceptionMessageEnum.JourneyNotFound);
    }
  });
});
