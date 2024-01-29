import { Module } from '@nestjs/common';
import { JourneyController } from '../controller/journey.controller';
import { JourneyService } from '../service/journey.service';
import { MongooseModule } from '@nestjs/mongoose';
// import { JourneySchema, Journey } from '../schema/journey.schema';
import { UserService } from '../../user/serivce/user.service';
// import { User, UserSchema } from 'src/user/schema/user.schema';
import { UserModule } from '../../user/module/user.module';
import { JourneyRepository } from '../repository/journey.repository';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserRepository } from 'src/user/repository/user.repository';
import { TypeOrmExModule } from 'src/dynamic.module';
import { SpotRepository } from 'src/spot/repository/spot.repository';
import { Spot } from '../../spot/entities/spot.entity';

@Module({
  imports: [
    TypeOrmExModule.forFeature([JourneyRepository, UserRepository, SpotRepository, Spot]),
    // MongooseModule.forFeature([{ name: Journey.name, schema: JourneySchema }]),
    // MongooseModule.forFeature([{ name: User.name, schema: UserSchema }]),
    UserModule,
  ],
  controllers: [JourneyController],
  providers: [JourneyService, UserService],
})
export class JourneyModule {}
