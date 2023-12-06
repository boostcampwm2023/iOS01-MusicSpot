import { Test, TestingModule } from '@nestjs/testing';
import { UserService } from './user.service';
import { getModelToken } from '@nestjs/mongoose';
import { User, UserSchema } from '../schema/user.schema';
import mongoose from 'mongoose';
import { CreateUserDTO } from '../dto/createUser.dto';

describe('UserService', () => {
  let service: UserService;
  let userModel;
  beforeEach(async () => {
    const MockUserModel = {
      exists: jest.fn(),
      save: jest.fn(),
    };
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UserService,
        {
          provide: getModelToken(User.name),
          useValue: MockUserModel,
        },
      ],
    }).compile();

    service = module.get<UserService>(UserService);
    userModel = module.get(getModelToken(User.name));
  });

  it('create user test(success)', async () => {
    userModel.exists.mockResolvedValue(false);
    userModel.save.mockResolvedValue(true);
    const createUserDto: CreateUserDTO = {
      userId: 'ab4068ef-95ed-40c3-be6d-3db35df866b7',
    };
    const updatedUser = await service.create(createUserDto);
    console.log(updatedUser);
    const { userId, journeys } = updatedUser;

    expect(userId).toEqual(createUserDto.userId);
    expect(journeys).toEqual([]);
  });
  afterAll(async () => {
    mongoose.connection.close();
  });
});
