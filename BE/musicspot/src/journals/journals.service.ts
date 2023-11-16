import { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import { Injectable } from '@nestjs/common';
import { StartJournalDTO } from './dto/journalStart.dto';
import { Journal } from './journals.schema';
import { PersonService } from '../person/person.service';

@Injectable()
export class JournalsService {
  constructor(
    @InjectModel(Journal.name) private journalModel: Model<Journal>,
    private personService: PersonService,
  ) {}

  async create(startJournalDTO: StartJournalDTO): Promise<Journal> {
    const journalData = {
      ...startJournalDTO,
      spots: [],
      coordinates: [startJournalDTO.coordinate],
    };
    const createdJournal = new this.journalModel(journalData);
    const returnData = await createdJournal.save();
    const journalId = returnData._id;
    this.personService.appendJournalIdToPerson(
      startJournalDTO.email,
      journalId,
    );
    return returnData;
  }
}
