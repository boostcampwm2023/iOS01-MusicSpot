import {
  Controller,
  Body,
  Post,
  Param,
  Version,
  Get,
  UsePipes,
  ValidationPipe,
  Query,
} from '@nestjs/common';
import { UserService } from '../serivce/user.service';
import { CreateUserDTO } from '../dto/createUser.dto';
import {
  ApiCreatedResponse,
  ApiOperation,
  ApiQuery,
  ApiTags,
} from '@nestjs/swagger';
import { User } from '../entities/user.entity';
import {
  StartJourneyRequestDTOV2,
  StartJourneyResponseDTOV2,
} from '../dto/startJourney.dto';
import { Journey } from '../../journey/entities/journey.entity';
import { CheckJourneyResDTO } from '../../journey/dto/journeyCheck/journeyCheck.dto';
import { UUID } from 'crypto';
import { LastJourneyResDTO } from '../../journey/dto/journeyLast.dto';
import { StartJourneyResDTO } from '../../journey/dto/journeyStart/journeyStart.dto';
import { JourneyV2DTO } from '../../journey/dto/v2/jounrey.dto';
import {LastJourneyResV2DTO} from "../../journey/dto/v2/lastJourney.dto.v2";

@Controller('user')
export class UserController {
  constructor(private userService: UserService) {}

  @ApiTags('User V1')
  @ApiOperation({
    summary: '유저 생성 API',
    description: '첫 시작 시 유저를 생성합니다.',
  })
  @ApiCreatedResponse({
    description: '생성된 유저 데이터를 반환',
    type: User,
  })
  @Post()
  async create(@Body() createUserDto: CreateUserDTO): Promise<User> {
    return await this.userService.create(createUserDto);
  }
  @ApiTags('Journey V2')
  @Version('2')
  @ApiOperation({
    summary: '여정 시작 API',
    description: '여정을 시작합니다.',
  })
  @ApiCreatedResponse({
    description: '생성된 여정 데이터를 반환',
    type: StartJourneyResponseDTOV2,
  })
  @Post(':userId/journey/start')
  async startJourney(
    @Param('userId') userId: string,
    @Body() startJourneyDto: StartJourneyRequestDTOV2,
  ) {
    return await this.userService.startJourney(userId, startJourneyDto);
  }

  @ApiTags('Journey V2')
  @Version('2')
  @ApiOperation({
    summary: '여정 조회 API(Coordiante 범위)',
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
    type: JourneyV2DTO,
  })
  @Get(':userId/journey')
  @UsePipes(ValidationPipe)
  async getJourneyByCoordinate(
    @Param('userId') userId: UUID,
    @Query('minCoordinate') minCoordinate: string,
    @Query('maxCoordinate') maxCoordinate: string,
  ) {
    console.log('min:', minCoordinate, 'max:', maxCoordinate);
    try {
      const checkJourneyDTO = {
        userId,
        minCoordinate,
        maxCoordinate,
      };
      return await this.userService.getJourneyByCoordinationRangeV2(
        checkJourneyDTO,
      );
    } catch (err) {
      console.log(err);
    }
  }
  @ApiTags('Journey V2')
  @Version('2')
  @ApiOperation({
    summary: '마지막 여정 진행 중 여부 확인 API',
    description: '진행 중인 여정이 있었는 지 확인',
  })
  @ApiCreatedResponse({
    description: '사용자가 진행중이었던 여정 정보',
    type: LastJourneyResV2DTO,
  })
  @Get(':userId/journey/last')
  async loadLastDataV2(@Param('userId') userId: UUID) {
    try {
      return await this.userService.getLastJourneyByUserIdV2(userId);
    } catch (err) {
      console.log(err);
    }
  }
}
