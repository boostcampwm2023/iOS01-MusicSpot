import { Controller, Post, Body } from '@nestjs/common';
import { JourneyService } from '../service/journey.service';
import { StartJourneyDTO } from '.././dto/journeyStart.dto';
import { ApiCreatedResponse, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Journey } from '../schema/journey.schema';
import { EndJourneyDTO } from '.././dto/journeyEnd.dto';
import { RecordJourneyDTO } from '.././dto/journeyRecord.dto';

@Controller('journey')
@ApiTags('journey 관련 API')
export class JourneyController {
  constructor(private journeyService: JourneyService) {}

  @ApiOperation({
    summary: '여정 시작 API',
    description: '여정 기록을 시작합니다..',
  })
  @ApiCreatedResponse({
    description: '생성된 여정 데이터를 반환',
    type: Journey,
  })
  @Post('start')
  async create(@Body() startJourneyDTO: StartJourneyDTO) {
    return await this.journeyService.create(startJourneyDTO);
  }
  @ApiOperation({
    summary: '여정 종료 API',
    description: '여정을 종료합니다.',
  })
  @ApiCreatedResponse({
    description: '현재는 좌표 데이터의 길이를 반환, 추후 참 거짓으로 변경 예정',
    type: Journey,
  })
  @Post('end')
  async end(@Body() endJourneyDTO: EndJourneyDTO) {
    return await this.journeyService.end(endJourneyDTO);
  }

  @ApiOperation({
    summary: '여정 좌표 기록API',
    description: '여정의 좌표를 기록합니다.',
  })
  @ApiCreatedResponse({
    description: '생성된 여정 데이터를 반환',
    type: Journey,
  })
  @Post('record')
  async record(@Body() recordJourneyDTO: RecordJourneyDTO) {
    return await this.journeyService.pushCoordianteToJourney(recordJourneyDTO);
  }
}
