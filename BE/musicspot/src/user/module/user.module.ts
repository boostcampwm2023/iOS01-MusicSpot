import { Module } from '@nestjs/common';
import { UserController } from '../controller/user.controller';
import { UserService } from '../serivce/user.service';
// import { User, UserSchema } from '../schema/user.schema';
import { MongooseModule } from '@nestjs/mongoose';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserRepository } from '../repository/user.repository';
import { TypeOrmExModule } from 'src/dynamic.module';

@Module({
  imports: [
    TypeOrmExModule.forFeature([UserRepository])
    // MongooseModule.forFeature([{ name: User.name, schema: UserSchema }]),
  ],
  controllers: [UserController],
  providers: [UserService],
  exports: [UserModule],
})
export class UserModule {}
