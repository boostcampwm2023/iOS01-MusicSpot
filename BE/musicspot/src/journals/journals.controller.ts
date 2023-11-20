import { Controller, Post, Body } from '@nestjs/common';
import { JournalsService } from './journals.service';
import { StartJournalDTO } from './dto/journalStart.dto';
@Controller('journals')
export class JournalsController {
  constructor(private journalsService: JournalsService) {}

  @Post()
  async create(@Body() startJournalDTO: StartJournalDTO) {
    return await this.journalsService.create(startJournalDTO);
  }
}
