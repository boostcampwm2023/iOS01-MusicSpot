import { Test, TestingModule } from '@nestjs/testing';
import { JournalsService } from './journals.service';
import mongoose, { mongo } from 'mongoose';
import { Person, PersonSchema } from '../person/person.schema';
import { Journal, JournalSchema } from './journals.schema';
import { getModelToken } from '@nestjs/mongoose';
import { StartJournalDTO } from './dto/journalStart.dto';
import { PersonService } from '../person/person.service';

describe('JournalsService', () => {
  let service: JournalsService;
  let personModel;
  let journalModel;
  beforeEach(async () => {
    mongoose.connect('mongodb://192.168.174.128:27017/musicspotDB');
    personModel = mongoose.model(Person.name, PersonSchema);
    journalModel = mongoose.model(Journal.name, JournalSchema);

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        JournalsService,
        PersonService,
        {
          provide: getModelToken(Journal.name),
          useValue: journalModel,
        },
        {
          provide: getModelToken(Person.name),
          useValue: personModel,
        },
      ],
    }).compile();

    service = module.get<JournalsService>(JournalsService);
  });

  it('journal 시작 테스트', async () => {
    const insertData: StartJournalDTO = {
      title: 'test2',
      coordinate: [100, 100],
      timestamp: 'time test code',
      email: 'test',
    };
    const dataLength = (await journalModel.find().exec()).length;
    const journalLength = (await personModel.find({ email: 'test' }).exec())[0]
      .journals.length;

    await service.create(insertData);
    const nextDataLength = (await journalModel.find().exec()).length;
    const nextJournalLength = (
      await personModel.find({ email: 'test' }).exec()
    )[0].journals.length;

    expect(dataLength + 1).toEqual(nextDataLength);
    expect(journalLength + 1).toEqual(nextJournalLength);
  });

  afterAll(async () => {
    mongoose.connection.close();
  });
});
