import { Controller, Post, Body } from '@nestjs/common';
import { JourneyService } from './journey.service';
import { StartJourneyDTO } from './dto/journeyStart.dto';
import { ApiCreatedResponse, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Journey } from './journey.schema';
import { EndJourneyDTO } from './dto/journeyEnd.dto';

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

  @Post('start')
  async create(@Body() startJourneyDTO: StartJourneyDTO) {
    return await this.journeyService.create(startJourneyDTO);
  }
  @ApiOperation({
    summary: '여정 종료를 눌렀을 시 실행되는 API',
    description: 'request로 id값이 필요합니다',
  })
  @ApiCreatedResponse({
    description: '현재는 좌표 데이터의 길이를 반환, 추후 참 거짓으로 변경 예정',
    type: Journey,
  })
  @Post('end')
  async end(@Body() endJourneyDTO: EndJourneyDTO) {
    return await this.journeyService.end(endJourneyDTO);
  }

}
