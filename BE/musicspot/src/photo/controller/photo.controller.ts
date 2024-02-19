import { Controller, Delete, Param, Version } from '@nestjs/common';
import { PhotoService } from '../service/photo.service';
import {ApiCreatedResponse, ApiOperation, ApiTags} from '@nestjs/swagger';
import { StartJourneyResDTO } from '../../journey/dto/journeyStart/journeyStart.dto';

@Controller('photo')
export class PhotoController {
  constructor(private photoService: PhotoService) {}

  @ApiTags('Photo V2')
  @Version('2')
  @ApiOperation({
    summary: '사진 삭제 API',
    description: '여정 기록을 시작합니다.',
  })
  @ApiCreatedResponse({
    description: '생성된 여정 데이터를 반환',
    type: StartJourneyResDTO,
  })
  @Delete(':photoId')
  async deletePhoto(@Param('photoId') photoId) {
    return await this.photoService.deletePhoto(photoId);
  }
}
