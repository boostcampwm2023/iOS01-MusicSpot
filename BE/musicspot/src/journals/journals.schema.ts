import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

export type JournalDocument = HydratedDocument<Journal>;

@Schema({ collection: 'journals' })
export class Journal {
  @Prop()
  title: string;

  @Prop()
  spots: string[];

  @Prop({ type: [[Number]] })
  coordinates: number[][];
}

export const JournalSchema = SchemaFactory.createForClass(Journal);
