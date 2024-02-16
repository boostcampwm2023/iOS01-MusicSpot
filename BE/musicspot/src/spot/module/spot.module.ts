import { Module } from '@nestjs/common';
import { SpotController } from '../controller/spot.controller';
import { SpotService } from '../service/spot.service';
import { MongooseModule } from '@nestjs/mongoose';
import { Spot, SpotSchema } from '../schema/spot.schema';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SpotRepository } from '../repository/spot.repository';
import { TypeOrmExModule } from 'src/dynamic.module';
import { JourneyRepository } from 'src/journey/repository/journey.repository';
import { Journey } from '../../journey/entities/journey.entity';
// import { Journey, JourneySchema } from 'src/journey/schema/journey.schema';
@Module({
  imports: [
    // TypeOrmExModule.forFeature([SpotRepository, JourneyRepository])
    // MongooseModule.forFeature([
    //   { name: Spot.name, schema: SpotSchema },
    //   { name: Journey.name, schema: JourneySchema },
    // ]),
    TypeOrmModule.forFeature([Spot, Journey]),
  ],
  controllers: [SpotController],
  providers: [SpotService],
})
export class SpotModule {}
