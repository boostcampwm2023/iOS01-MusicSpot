import {Controller, Body, Post, Param, Version} from '@nestjs/common';
import { UserService } from '../serivce/user.service';
import { CreateUserDTO } from '../dto/createUser.dto';
import { ApiCreatedResponse, ApiOperation, ApiTags } from '@nestjs/swagger';
import { User } from '../entities/user.entity';
import {StartJourneyRequestDTOV2} from "../dto/startJourney.dto";
import {Journey} from "../../journey/entities/journey.entity";

@Controller('user')
@ApiTags('user 관련 API')
export class UserController {
  constructor(private userService: UserService) {}

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


  @Version('2')
  @ApiOperation({
    summary: '여정 시작 API',
    description: '여정을 시작합니다.',
  })
  @ApiCreatedResponse({
    description: '생성된 여정 데이터를 반환',
    type: Journey,
  })
  @Post(':userId/journey/start')
  async startJourney(@Param('userId') userId:string, @Body() startJourneyDto: StartJourneyRequestDTOV2) {
    return await this.userService.startJourney(userId, startJourneyDto);
  }
}
