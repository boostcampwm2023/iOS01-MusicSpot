import {
  Controller,
  Post,
  Body,
  UsePipes,
  ValidationPipe,
  Get,
  Query,
  Param,
  Delete,
  Version,
  UseInterceptors,
  UploadedFiles,
} from '@nestjs/common';
import { JourneyService } from '../service/journey.service';
import { StartJourneyReqDTO } from '../dto/journeyStart/journeyStart.dto';
import {
  ApiCreatedResponse,
  ApiOperation,
  ApiQuery,
  ApiTags,
} from '@nestjs/swagger';
import {
  CheckJourneyResDTO,
  CheckJourneyReqDTO,
} from '../dto/journeyCheck/journeyCheck.dto';
import { UUID } from 'crypto';
import {
  EndJourneyReqDTO,
  EndJourneyResDTO,
} from '../dto/journeyEnd/journeyEnd.dto';
import {
  RecordJourneyReqDTO,
  RecordJourneyResDTO,
} from '../dto/journeyRecord/journeyRecord.dto';
import { StartJourneyResDTO } from '../dto/journeyStart/journeyStart.dto';
import { DeleteJourneyReqDTO } from '../dto/journeyDelete.dto';

import { Journey } from '../entities/journey.entity';
import { LastJourneyResDTO } from '../dto/journeyLast.dto';
import {
  StartJourneyReqDTOV2,
  StartJourneyResDTOV2,
} from '../dto/v2/startJourney.v2.dto';
import {
  EndJourneyReqDTOV2,
  EndJourneyResDTOV2,
} from '../dto/v2/endJourney.v2.dto';
import { FilesInterceptor } from '@nestjs/platform-express';
import { RecordSpotReqDTOV2 } from '../../spot/dto/v2/recordSpot.v2.dto';

@Controller('journey')
@ApiTags('journey 관련 API')
export class JourneyController {
  constructor(private journeyService: JourneyService) {}

  @ApiOperation({
    summary: '여정 시작 API',
    description: '여정 기록을 시작합니다.',
  })
  @ApiCreatedResponse({
    description: '생성된 여정 데이터를 반환',
    type: StartJourneyResDTO,
  })
  @Post('/start')
  async create(@Body() startJourneyDTO: StartJourneyReqDTO) {
    return await this.journeyService.insertJourneyData(startJourneyDTO);
  }

  // @Version('2')
  // @ApiOperation({
  //   summary: '여정 시작 API(V2)',
  //   description: '여정 기록을 시작합니다.',
  // })
  // @ApiCreatedResponse({
  //   description: '생성된 여정 데이터를 반환',
  //   type: StartJourneyResDTOV2,
  // })
  // @Post('start')
  // async createV2(@Body() startJourneyDTO: StartJourneyReqDTOV2) {
  //   try {
  //     return await this.journeyService.insertJourneyDataV2(startJourneyDTO);
  //   } catch (err) {
  //     console.log(err);
  //   }
  // }

  @ApiOperation({
    summary: '여정 종료 API',
    description: '여정을 종료합니다.',
  })
  @ApiCreatedResponse({
    description: '여정 종료 정보 반환',
    type: EndJourneyResDTO,
  })
  @Post('end')
  async end(@Body() endJourneyReqDTO: EndJourneyReqDTO) {
    return await this.journeyService.end(endJourneyReqDTO);
  }

  @Version('2')
  @ApiOperation({
    summary: '여정 종료 API(V2)',
    description: '여정을 종료합니다.',
  })
  @ApiCreatedResponse({
    description: '여정 종료 정보 반환',
    type: EndJourneyResDTOV2,
  })
  @Post(':journeyId/end')
  async endV2(@Param('journeyId') journeyId:number, @Body() endJourneyReqDTO: EndJourneyReqDTOV2) {
    try {
      return await this.journeyService.endV2(journeyId, endJourneyReqDTO);
    } catch (err) {
      console.log(err);
    }
  }

  @ApiOperation({
    summary: '여정 좌표 기록API',
    description: '여정의 좌표를 기록합니다.',
  })
  @ApiCreatedResponse({
    description: '생성된 여정 데이터를 반환',
    type: RecordJourneyResDTO,
  })
  @Post('record')
  async record(@Body() recordJourneyDTO: RecordJourneyReqDTO) {
    const returnData =
      await this.journeyService.pushCoordianteToJourney(recordJourneyDTO);
    return returnData;
  }

  @Version('2')
  @ApiOperation({
    summary: '여정 조회 API',
    description: '해당 범위 내의 여정들을 반환합니다.',
  })
  @ApiQuery({
    name: 'userId',
    description: '유저 ID',
    required: true,
    example: 'yourUserId',
  })
  @ApiQuery({
    name: 'minCoordinate',
    description: '최소 좌표',
    required: true,
    example: '37.5 127.0',
  })
  @ApiQuery({
    name: 'maxCoordinate',
    description: '최대 좌표',
    required: true,
    example: '38.0 128.0',
  })
  @ApiCreatedResponse({
    description: '범위에 있는 여정의 기록들을 반환',
    type: CheckJourneyResDTO,
  })
  @Get()
  @UsePipes(ValidationPipe)
  async getJourneyByCoordinate(
    @Query('userId') userId: UUID,
    @Query('minCoordinate') minCoordinate: string,
    @Query('maxCoordinate') maxCoordinate: string,
  ) {
    console.log('min:', minCoordinate, 'max:', maxCoordinate);
    const checkJourneyDTO = {
      userId,
      minCoordinate,
      maxCoordinate,
    };
    return await this.journeyService.getJourneyByCoordinationRangeV2(
      checkJourneyDTO,
    );
  }
  @ApiOperation({
    summary: '여정 조회 API',
    description: '해당 범위 내의 여정들을 반환합니다.',
  })
  @ApiQuery({
    name: 'userId',
    description: '유저 ID',
    required: true,
    example: 'yourUserId',
  })
  @ApiQuery({
    name: 'minCoordinate',
    description: '최소 좌표',
    required: true,
    type: Number,
    isArray: true,
    example: [37.5, 127.0],
  })
  @ApiQuery({
    name: 'maxCoordinate',
    description: '최대 좌표',
    required: true,
    type: Number,
    isArray: true,
    example: [38.0, 128.0],
  })
  @ApiCreatedResponse({
    description: '범위에 있는 여정의 기록들을 반환',
    type: CheckJourneyResDTO,
  })
  @Get('check')
  @UsePipes(ValidationPipe)
  async checkGet(
    @Query('userId') userId: UUID,
    @Query('minCoordinate') minCoordinate,
    @Query('maxCoordinate') maxCoordinate,
  ) {
    console.log('min:', minCoordinate, 'max:', maxCoordinate);
    const checkJourneyDTO = {
      userId,
      minCoordinate,
      maxCoordinate,
    };
    return await this.journeyService.getJourneyByCoordinationRange(
      checkJourneyDTO,
    );
  }

  @Version('2')
  @ApiOperation({
    summary: '최근 여정 조회 API',
    description: '진행 중인 여정이 있었는 지 확인',
  })
  @ApiCreatedResponse({
    description: '사용자가 진행중이었던 여정 정보',
    type: LastJourneyResDTO,
  })
  @Get('last')
  async loadLastDataV2(@Body('userId') userId) {
    try {
      return await this.journeyService.getLastJourneyByUserIdV2(userId);
    } catch (err) {
      console.log(err);
    }
  }
  @ApiOperation({
    summary: '최근 여정 조회 API',
    description: '진행 중인 여정이 있었는 지 확인',
  })
  @ApiCreatedResponse({
    description: '사용자가 진행중이었던 여정 정보',
    type: LastJourneyResDTO,
  })
  @Get('last')
  async loadLastData(@Body('userId') userId) {
    return await this.journeyService.getLastJourneyByUserId(userId);
  }

  @Version('2')
  @ApiOperation({
    summary: '여정 조회 API',
    description: 'journey id를 통해 여정을 조회',
  })
  @ApiCreatedResponse({
    description: 'journey id에 해당하는 여정을 반환',
    type: [Journey],
  })
  @Get(':journeyId')
  async getJourneyByIdV2(@Param('journeyId') journeyId: number) {
    try {
      return await this.journeyService.getJourneyByIdV2(journeyId);
    } catch (err) {
      console.log(err);
    }
  }

  @ApiOperation({
    summary: '여정 조회 API',
    description: 'journey id를 통해 여정을 조회',
  })
  @ApiCreatedResponse({
    description: 'journey id에 해당하는 여정을 반환',
    type: [Journey],
  })
  @Get(':journeyId')
  async getJourneyById(@Param('journeyId') journeyId: string) {
    return await this.journeyService.getJourneyById(journeyId);
  }

  @ApiOperation({
    summary: '여정 삭제 api',
    description: 'journey id에 따른 여정 삭제',
  })
  @ApiCreatedResponse({
    description: '삭제된 여정을 반환',
    type: Journey,
  })
  @Delete('')
  async deleteJourneyById(@Body() deleteJourneyDto: DeleteJourneyReqDTO) {
    return await this.journeyService.deleteJourneyById(deleteJourneyDto);
  }

  @Version('2')
  @ApiOperation({
    summary: 'spot 저장 api(V2)',
    description: '복수개의 사진을 가지는 spot을 저장',
  })
  @ApiCreatedResponse({
    description: '저장된 spot을 반환(presigned url)',
  })
  @UseInterceptors(FilesInterceptor('images'))
  @Post(':journeyId/spot')
  async saveSpotToJourney(
    @UploadedFiles() images: Array<Express.Multer.File>,
    @Param('journeyId') journeyId: string,
    @Body() recordSpotDto: RecordSpotReqDTOV2,
  ) {
    try {
      return await this.journeyService.saveSpot(
        images,
        journeyId,
        recordSpotDto,
      );
    } catch (err) {
      console.log(err);
    }
  }
}
