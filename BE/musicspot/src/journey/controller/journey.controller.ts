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
    return await this.journeyService.insertJourneyData(startJourneyDTO);
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
    console.log('min:', minCoordinate, 'max:', maxCoordinate);
    const checkJourneyDTO = {
      userId,
      minCoordinate,
      maxCoordinate,
    };
    return await this.journeyService.getJourneyByCoordinationRange(checkJourneyDTO);
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
}

