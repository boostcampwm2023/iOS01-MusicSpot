import { Test, TestingModule } from '@nestjs/testing';
import { PersonService } from './person.service';
import { getModelToken } from '@nestjs/mongoose';
import { Person, PersonSchema } from './person.schema';
import mongoose from 'mongoose';

describe('PersonService', () => {
  let service: PersonService;
  let personModel;
  beforeEach(async () => {
    mongoose.connect('mongodb://192.168.174.128:27017/musicspotDB');
    personModel = mongoose.model(Person.name, PersonSchema);
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PersonService,
        {
          provide: getModelToken(Person.name),
          useValue: personModel,
        },
      ],
    }).compile();

    service = module.get<PersonService>(PersonService);
  });

  it('journal id 삽입 테스트', async () => {
    const data = new Object(await personModel.find({ email: 'test' }))[0];

    const pervLength = data.journals.length;
    await service.appendJournalIdToPerson('test', '2');

    const nextData = new Object(await personModel.find({ email: 'test' }))[0];
    const nextLength = nextData.journals.length;
    expect(nextLength).toEqual(pervLength + 1);
  });

  afterAll(async () => {
    mongoose.connection.close();
  });
});
