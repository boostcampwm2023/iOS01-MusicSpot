import { Controller, Post, Body } from '@nestjs/common';
import { JournalsService } from './journals.service';
import { StartJournalDTO } from './dto/journalStart.dto';
import { ApiCreatedResponse, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Journal } from './journals.schema';
@Controller('journals')
@ApiTags('journal 관련 API')
export class JournalsController {
  constructor(private journalsService: JournalsService) {}

  @ApiOperation({
    summary: '여정 시작을 눌렀을 시 실행되는 API',
    description:
      'request로 여정 제목, 위치좌표(number[], 2개), 시작 시간, 유저 이메일을 필요합니다.',
  })
  @ApiCreatedResponse({
    description: '생성된 여정 데이터를 반환',
    type: Journal,
  })
  @Post()
  async create(@Body() startJournalDTO: StartJournalDTO) {
    return await this.journalsService.create(startJournalDTO);
  }
}
