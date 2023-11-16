import { Module } from '@nestjs/common';
import { JournalsController } from './journals.controller';
import { JournalsService } from './journals.service';
import { MongooseModule } from '@nestjs/mongoose';
import { JournalSchema, Journal } from './journals.schema';
import { PersonService } from '../person/person.service';
import { Person, PersonSchema } from 'src/person/person.schema';
import { PersonModule } from '../person/person.module';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Journal.name, schema: JournalSchema }]),
    MongooseModule.forFeature([{ name: Person.name, schema: PersonSchema }]),
    PersonModule,
  ],
  controllers: [JournalsController],
  providers: [JournalsService, PersonService],
})
export class JournalsModule {}
