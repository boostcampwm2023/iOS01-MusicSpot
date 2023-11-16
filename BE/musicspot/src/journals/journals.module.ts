import { Module } from '@nestjs/common';
import { JournalsController } from './journals.controller';
import { JournalsService } from './journals.service';
import { MongooseModule } from '@nestjs/mongoose';
import { JournalSchema, Journal } from './journals.schema';
import { PersonService } from 'src/person/person.service';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Journal.name, schema: JournalSchema }]),
    PersonService,
  ],
  controllers: [JournalsController],
  providers: [JournalsService, PersonService],
})
export class JournalsModule {}
