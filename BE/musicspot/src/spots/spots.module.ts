import { Module } from '@nestjs/common';
import { SpotsController } from './spots.controller';
import { SpotsService } from './spots.service';
import { MongooseModule } from '@nestjs/mongoose';
import { Spot, SpotSchema } from './spots.schema';
@Module({
  imports: [
    MongooseModule.forFeature([{ name: Spot.name, schema: SpotSchema }]),
  ],
  controllers: [SpotsController],
  providers: [SpotsService],
})
export class SpotsModule {}
