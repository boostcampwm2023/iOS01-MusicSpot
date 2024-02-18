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
import { PhotoRepository } from '../../photo/photo.repository';
import { Photo } from '../../photo/entity/photo.entity';
import { Journey } from '../entities/journey.entity';
import { User } from '../../user/entities/user.entity';
import { JourneyV2 } from '../entities/journey.v2.entity';
import { SpotV2 } from '../../spot/entities/spot.v2.entity';

@Module({
  imports: [
    // TypeOrmExModule.forFeature([
    //   JourneyRepository,
    //   UserRepository,
    //   SpotRepository,
    //   Spot,
    //   Photo,
    //   PhotoRepository,
    // ]),
    // MongooseModule.forFeature([{ name: Journey.name, schema: JourneySchema }]),
    // MongooseModule.forFeature([{ name: User.name, schema: UserSchema }]),
    TypeOrmModule.forFeature([Journey, User, Spot, Photo, JourneyV2, SpotV2]),
    UserModule,
  ],
  controllers: [JourneyController],
  providers: [JourneyService, UserService],
})
export class JourneyModule {}
