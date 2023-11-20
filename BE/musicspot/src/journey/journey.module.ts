import { Module } from '@nestjs/common';
import { JourneyController } from './journey.controller';
import { JourneyService } from './journey.service';
import { MongooseModule } from '@nestjs/mongoose';
import { JourneySchema, Journey } from './journey.schema';
import { UserService } from '../user/user.service';
import { User, UserSchema } from 'src/user/user.schema';
import { UserModule } from '../user/user.module';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Journey.name, schema: JourneySchema }]),
    MongooseModule.forFeature([{ name: User.name, schema: UserSchema }]),
    UserModule,
  ],
  controllers: [JourneyController],
  providers: [JourneyService, UserService],
})
export class JourneyModule {}
