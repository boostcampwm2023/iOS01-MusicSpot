import { Test, TestingModule } from '@nestjs/testing';
import { SpotController } from './spot.controller';

describe('SpotController', () => {
  let controller: SpotController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [SpotController],
    }).compile();

    controller = module.get<SpotController>(SpotController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
