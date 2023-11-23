import {
  Controller,
  Post,
  Body,
  UseInterceptors,
  UploadedFile,
} from '@nestjs/common';
import { ApiCreatedResponse, ApiOperation, ApiTags } from '@nestjs/swagger';
import { RecordSpotDTO } from '../dto/recordSpot.dto';
import { SpotService } from '../service/spot.service';
import { FileInterceptor } from '@nestjs/platform-express';
import { Spot } from '../schema/spot.schema';
@Controller('spot')
@ApiTags('spot 관련 API')
export class SpotController {
  constructor(private spotService: SpotService) {}

  @ApiOperation({
    summary: 'spot 기록 시 실행되는 API',
    description:
      'request로 여정 ID(string), 위치좌표([number, number]), timestamp(string), 유저 이메일(string)을 필요합니다.',
  })
  @ApiCreatedResponse({
    description: '생성된 spot 데이터를 반환',
    type: Spot,
  })
  @Post()
  async create(@Body() recordSpotDTO: RecordSpotDTO) {
    return await this.spotService.create(recordSpotDTO);
  }
}
