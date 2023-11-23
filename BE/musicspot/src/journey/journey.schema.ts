import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

export type JourneyDocument = HydratedDocument<Journey>;

@Schema({ collection: 'journey' })
export class Journey {
  @Prop()
  title: string;

  @Prop()
  spots: string[];

  @Prop({ type: [[Number]] })
  coordinates: number[][];

  @Prop({ type: String })
  timestamp: string;

}

export const JourneySchema = SchemaFactory.createForClass(Journey);
