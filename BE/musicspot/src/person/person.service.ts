import { Injectable } from '@nestjs/common';
import { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import { Person } from './person.schema';
@Injectable()
export class PersonService {
  constructor(@InjectModel(Person.name) private personModel: Model<Person>) {}
  async appendJournalIdToPerson(
    personEmail: string,
    journalId: Object,
  ): Promise<any> {
    return this.personModel.updateOne(
      { email: personEmail },
      { $push: { journals: journalId } },
    );
  }
}
