import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Collection, HydratedDocument } from 'mongoose';

export type PersonDocument = HydratedDocument<Person>;

@Schema({ collection: 'person' })
export class Person {
  @Prop()
  email: string;

  @Prop()
  nickname: string;

  @Prop()
  journals: string[];
}

export const PersonSchema = SchemaFactory.createForClass(Person);
