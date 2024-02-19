import {
  Controller,
  Post,
  Body,
  UseInterceptors,
  UploadedFile,
  Get,
  Query,
  Version,
  Param,
  UploadedFiles,
} from '@nestjs/common';
import { ApiCreatedResponse, ApiOperation, ApiTags } from '@nestjs/swagger';
import { RecordSpotReqDTO } from '../dto/recordSpot.dto';
import { SpotService } from '../service/spot.service';
import { FileInterceptor, FilesInterceptor } from '@nestjs/platform-express';
import { Spot } from '../schema/spot.schema';
import { SpotDTO } from 'src/journey/dto/journeyCheck/journeyCheck.dto';
import { RecordSpotReqDTOV2 } from '../dto/v2/recordSpot.v2.dto';
import { Photo } from '../../photo/entity/photo.entity';
@Controller('spot')
export class SpotController {
  constructor(private spotService: SpotService) {}

  @ApiTags('Spot V1')
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

  // @Version('2')
  // @ApiOperation({
  //   summary: 'photo 저장 api',
  //   description: 'photo를 기록합니다.',
  // })
  // @ApiCreatedResponse({
  //   description: 'photo 생성 데이터 반환',
  //   type: Photo,
  // })
  // @UseInterceptors(FilesInterceptor('images'))
  // @Post(':spotId/photo')
  // async savePhoto(
  //   @UploadedFiles() images: Array<Express.Multer.File>,
  //   @Param('spotId') spotId: number,
  // ) {
  //   try {
  //     return this.spotService.savePhoto(images, spotId);
  //   } catch (err) {
  //     console.log(err);
  //   }
  // }

  @ApiTags('Spot V1')
  @ApiOperation({
    summary: 'spot 조회 API',
    description: 'spotId로 스팟 이미지를 조회합니다.',
  })
  @ApiCreatedResponse({
    description: 'spot 데이터를 반환',
    type: SpotDTO,
  })
  @Get('find')
  async findSpotImage(@Query('spotId') spotId: number) {
    try {
      return await this.spotService.getSpotImage(spotId);
    } catch (err) {
      console.log(err);
    }
  }

  // @ApiOperation({
  //   summary : 'spot에 photo 추가',
  //   t
  // })
  // @Post(":spotId/photo")
  // async insertPhotoToSpot(@Param('spotId') spotId: number){
  //
  // }

  // @Post()
  // async create(@Body() recordSpotDTO: RecordSpotDTO) {
  //   return await this.spotService.create(recordSpotDTO);
  // }
}
