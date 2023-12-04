import { Controller, Body, Post } from '@nestjs/common';
import { UserService } from '../serivce/user.service';
import { CreateUserDTO } from '../dto/createUser.dto';
import { User } from '../schema/user.schema';
import { ApiCreatedResponse, ApiOperation, ApiTags } from '@nestjs/swagger';
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
}
