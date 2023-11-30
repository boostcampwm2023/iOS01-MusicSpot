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
    summary: 'spot 기록 API',
    description: 'spot을 기록합니다.',
  })
  @ApiCreatedResponse({
    description: '생성된 spot 데이터를 반환',
    type: Spot,
  })
  @UseInterceptors(FileInterceptor('image'))
  @Post()
  async create(
    @UploadedFile() file: Express.Multer.File,
    @Body() recordSpotDTO: RecordSpotDTO,
  ) {
    return await this.spotService.create(file, recordSpotDTO);
  }
  // @Post()
  // async create(@Body() recordSpotDTO: RecordSpotDTO) {
  //   return await this.spotService.create(recordSpotDTO);
  // }
}
