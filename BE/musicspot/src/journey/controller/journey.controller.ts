import {
  Controller,
  Post,
  Body,
  UsePipes,
  ValidationPipe,
  Get,
  Query,
} from '@nestjs/common';
import { JourneyService } from '../service/journey.service';
import { StartJourneyDTO } from '.././dto/journeyStart.dto';
import {
  ApiCreatedResponse,
  ApiOperation,
  ApiQuery,
  ApiTags,
} from '@nestjs/swagger';
import { Journey } from '../schema/journey.schema';
import { EndJourneyDTO } from '.././dto/journeyEnd.dto';
import { RecordJourneyDTO } from '.././dto/journeyRecord.dto';
import { CheckJourneyDTO } from '../dto/journeyCheck.dto';
import { EndJourneyResponseDTO } from '../dto/journeyEndResponse.dto';
import { CheckJourneyResponseDTO } from '../dto/journeyCheckResponse.dto';
import { RecordJourneyResponseDTO } from '../dto/journetRecordResponse.dto';

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
    type: Journey,
  })
  @Post('start')
  async create(@Body() startJourneyDTO: StartJourneyDTO): Promise<Journey> {
    return await this.journeyService.create(startJourneyDTO);
  }

  @ApiOperation({
    summary: '여정 종료 API',
    description: '여정을 종료합니다.',
  })
  @ApiCreatedResponse({
    description: '현재는 좌표 데이터의 길이를 반환, 추후 참 거짓으로 변경 예정',
    type: EndJourneyResponseDTO,
  })
  @Post('end')
  async end(@Body() endJourneyDTO: EndJourneyDTO) {
    return await this.journeyService.end(endJourneyDTO);
  }

  @ApiOperation({
    summary: '여정 좌표 기록API',
    description: '여정의 좌표를 기록합니다.',
  })
  @ApiCreatedResponse({
    description: '생성된 여정 데이터를 반환',
    type: RecordJourneyResponseDTO,
  })
  @Post('record')
  async record(@Body() recordJourneyDTO: RecordJourneyDTO) {
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
    type: CheckJourneyResponseDTO,
  })
  @Get('check')
  @UsePipes(ValidationPipe)
  async checkGet(
    @Query('userId') userId: string,
    @Query('minCoordinate') minCoordinate: number[],
    @Query('maxCoordinate') maxCoordinate: number[],
  ) {
    const checkJourneyDTO: CheckJourneyDTO = {
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
    type: CheckJourneyResponseDTO,
  })
  @Post('check')
  @UsePipes(ValidationPipe) //유효성 체크
  async checkPost(@Body() checkJourneyDTO: CheckJourneyDTO) {
    return await this.journeyService.checkJourney(checkJourneyDTO);
  }
}
