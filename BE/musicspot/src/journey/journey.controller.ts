import { Controller, Post, Body } from '@nestjs/common';
import { JourneyService } from './journey.service';
import { StartJourneyDTO } from './dto/journeyStart.dto';
import { ApiCreatedResponse, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Journey } from './journey.schema';
@Controller('journey')
@ApiTags('journey 관련 API')
export class JourneyController {
  constructor(private journeyService: JourneyService) {}

  @ApiOperation({
    summary: '여정 시작을 눌렀을 시 실행되는 API',
    description:
      'request로 여정 제목, 위치좌표(number[], 2개), 시작 시간, 유저 이메일을 필요합니다.',
  })
  @ApiCreatedResponse({
    description: '생성된 여정 데이터를 반환',
    type: Journey,
  })
  @Post()
  async create(@Body() startJourneyDTO: StartJourneyDTO) {
    return await this.journeyService.create(startJourneyDTO);
  }
}
