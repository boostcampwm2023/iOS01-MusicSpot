import { Test, TestingModule } from '@nestjs/testing';
import { JourneyController } from './journey.controller';

describe('JourneyController', () => {
  let controller: JourneyController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [JourneyController],
    }).compile();

    controller = module.get<JourneyController>(JourneyController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
