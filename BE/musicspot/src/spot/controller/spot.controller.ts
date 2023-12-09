import {
  Controller,
  Post,
  Body,
  UseInterceptors,
  UploadedFile,
  Get,
  Query,
} from '@nestjs/common';
import { ApiCreatedResponse, ApiOperation, ApiTags } from '@nestjs/swagger';
import { RecordSpotReqDTO } from '../dto/recordSpot.dto';
import { SpotService } from '../service/spot.service';
import { FileInterceptor } from '@nestjs/platform-express';
import { Spot } from '../schema/spot.schema';
import { SpotDTO } from 'src/journey/dto/journeyCheck/journeyCheck.dto';
@Controller('spot')
@ApiTags('spot 관련 API')
export class SpotController {
  constructor(private spotService: SpotService) {}

  @ApiOperation({
    summary: 'spot 기록 API',
    description: 'spot을 기록합니다.',
  })
  @ApiCreatedResponse({
    description: 'spot 생성 데이터 반환',
    type: SpotDTO,
  })
  @UseInterceptors(FileInterceptor('image'))
  @Post('')
  async create(
    @UploadedFile() file: Express.Multer.File,
    @Body() recordSpotDTO,
  ) {
    return await this.spotService.create(file, recordSpotDTO);
  }

  @ApiOperation({
    summary: 'spot 조회 API',
    description: 'spotId로 스팟 이미지를 조회합니다.',
  })
  @ApiCreatedResponse({
    description: 'spot 데이터를 반환',
    type: SpotDTO,
  })
  @Get('find')
  async findSpotImage(@Query('spotId') spotId: string) {
    try {
      return await this.spotService.getSpotImage(spotId);
    } catch (err) {
      console.log(err);
    }
  }

  // @Post()
  // async create(@Body() recordSpotDTO: RecordSpotDTO) {
  //   return await this.spotService.create(recordSpotDTO);
  // }
}
