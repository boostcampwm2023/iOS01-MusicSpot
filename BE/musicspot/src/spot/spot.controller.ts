import {
  Controller,
  Post,
  Body,
  UseInterceptors,
  UploadedFile,
} from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { RecordSpotDTO } from './dto/recordSpot.dto';
import { SpotService } from './spot.service';
import { FileInterceptor } from '@nestjs/platform-express';
@Controller('spot')
@ApiTags('spot 관련 API')
export class SpotController {
  constructor(private spotService: SpotService) {}
  @Post()
  async create(@Body() recordSpotDTO: RecordSpotDTO) {
    return await this.spotService.create(recordSpotDTO);
  }
}
