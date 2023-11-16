import { Controller, Post, Body } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { RecordSpotDTO } from './dto/recordSpot.dto';
import { SpotsService } from './spots.service';

@Controller('spots')
@ApiTags('spot 관련 API')
export class SpotsController {
  constructor(private spotService: SpotsService) {}
  @Post()
  async create(@Body() recordSpotDTO: RecordSpotDTO) {
    return await this.spotService.create(recordSpotDTO);
  }
}
