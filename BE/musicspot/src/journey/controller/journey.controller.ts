import {
  Controller,
  Post,
  Body,
  UsePipes,
  ValidationPipe,
  Get,
  Query,
  Param,
} from '@nestjs/common';
import { JourneyService } from '../service/journey.service';

import { StartJourneyReqDTO } from '../dto/journeyStart/journeyStart.dto';

import {
  ApiCreatedResponse,
  ApiOperation,
  ApiQuery,
  ApiTags,
} from '@nestjs/swagger';
import { Journey } from '../schema/journey.schema';
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
  @Post('start')
  async create(@Body() startJourneyDTO: StartJourneyReqDTO) {
    return await this.journeyService.create(startJourneyDTO);
  }

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
    const checkJourneyDTO = {
      userId,
      minCoordinate,
      maxCoordinate,
    };
    return await this.journeyService.checkJourney(checkJourneyDTO);
  }

  @ApiOperation({
    summary: '여정 조회 API',
    description: '해당 범위 내의 여정들을 반환합니다.',
  })
  @ApiCreatedResponse({
    description: '범위에 있는 여정의 기록들을 반환',
    type: CheckJourneyResDTO,
  })
  @Post('check')
  @UsePipes(ValidationPipe) //유효성 체크
  async checkPost(@Body() checkJourneyDTO: CheckJourneyReqDTO) {
    return await this.journeyService.checkJourney(checkJourneyDTO);
  }

  @ApiOperation({
    summary: '최근 여정 조회 API',
    description: '진행 중인 여정이 있었는 지 확인',
  })
  @ApiCreatedResponse({
    description: '사용자가 진행중이었던 여정 정보',
    type: Journey,
  })
  @Get('loadLastData')
  async loadLastData(@Query('userId') userId: string) {
    return await this.journeyService.loadLastJourney(userId);
  }

  @Get(':journeyId')
  async getJourneyById(@Param('journeyId') journeyId: string) {
    return await this.journeyService.getJourneyById(journeyId);
  }
}
