import * as fs from 'fs';
import * as path from 'path';
import { Test, TestingModule } from '@nestjs/testing';
import { SpotService } from './spot.service';
import {RecordSpotReqDTOV2} from "../dto/v2/recordSpot.v2.dto";
describe.skip('SpotService', () => {
  let service;
  beforeAll(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [SpotService],
    }).compile();

    service = module.get<SpotService>(SpotService);
  });

  it('spot 저장 테스트', () => {
    const insertData: RecordSpotReqDTOV2 ={}

  });
});
