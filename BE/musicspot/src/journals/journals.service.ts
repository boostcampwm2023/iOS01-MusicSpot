import { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import { Injectable } from '@nestjs/common';
import { StartJournalDTO } from './dto/journalStart.dto';
import { Journal } from './journals.schema';

@Injectable()
export class JournalsService {
  constructor(
    @InjectModel(Journal.name) private journalModel: Model<Journal>,
  ) {}

  async create(startJournalDTO: StartJournalDTO): Promise<Journal> {
    const journalData = {
      ...startJournalDTO,
      spots: [],
      coordinates: [startJournalDTO.coordinate],
    };
    const createdJournal = new this.journalModel(journalData);
    return createdJournal.save();
  }
}
