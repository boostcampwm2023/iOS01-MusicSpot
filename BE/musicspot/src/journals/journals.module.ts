import { Module } from '@nestjs/common';
import { JournalsController } from './journals.controller';
import { JournalsService } from './journals.service';
import { MongooseModule } from '@nestjs/mongoose';
import { JournalSchema, Journal } from './journals.schema';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Journal.name, schema: JournalSchema }]),
  ],
  controllers: [JournalsController],
  providers: [JournalsService],
})
export class JournalsModule {}
