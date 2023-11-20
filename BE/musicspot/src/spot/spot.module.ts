import { Module } from '@nestjs/common';
import { SpotController } from './spot.controller';
import { SpotService } from './spot.service';
import { MongooseModule } from '@nestjs/mongoose';
import { Spot, SpotSchema } from './spot.schema';
import { Journey, JourneySchema } from 'src/journey/journey.schema';
@Module({
  imports: [
    MongooseModule.forFeature([
      { name: Spot.name, schema: SpotSchema },
      { name: Journey.name, schema: JourneySchema },
    ]),
  ],
  controllers: [SpotController],
  providers: [SpotService],
})
export class SpotModule {}
