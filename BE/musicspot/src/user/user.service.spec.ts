import { Test, TestingModule } from '@nestjs/testing';
import { UserService } from './user.service';
import { getModelToken } from '@nestjs/mongoose';
import { User, UserSchema } from './user.schema';
import mongoose from 'mongoose';

describe('UserService', () => {
  let service: UserService;
  let userModel;
  beforeEach(async () => {
    mongoose.connect(
      `mongodb://${process.env.DB_HOST}:${process.env.DB_PORT}/${process.env.DB_NAME}`,
    );
    userModel = mongoose.model(User.name, UserSchema);
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UserService,
        {
          provide: getModelToken(User.name),
          useValue: userModel,
        },
      ],
    }).compile();

    service = module.get<UserService>(UserService);
  });

  it('journey id 삽입 테스트', async () => {
    const data = new Object(await userModel.find({ email: 'test' }))[0];

    const pervLength = data.journeys.length;
    await service.appendJourneyIdToUser('test', '2');

    const nextData = new Object(await userModel.find({ email: 'test' }))[0];
    const nextLength = nextData.journeys.length;
    expect(nextLength).toEqual(pervLength + 1);
  });

  afterAll(async () => {
    mongoose.connection.close();
  });
});
