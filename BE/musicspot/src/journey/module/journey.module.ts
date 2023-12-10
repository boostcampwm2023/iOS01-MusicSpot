import { Module } from '@nestjs/common';
import { JourneyController } from '../controller/journey.controller';
import { JourneyService } from '../service/journey.service';
import { MongooseModule } from '@nestjs/mongoose';
import { JourneySchema, Journey } from '../schema/journey.schema';
import { UserService } from '../../user/serivce/user.service';
import { User, UserSchema } from 'src/user/schema/user.schema';
import { UserModule } from '../../user/module/user.module';

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
