import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

export type SpotDocument = HydratedDocument<Spot>;

@Schema({ collection: 'spot' })
export class Spot {
  @Prop()
  journalId: string;

  @Prop({ type: [Number] })
  coordinate: number[];

  @Prop({ type: String })
  timestamp: string;
}

export const SpotSchema = SchemaFactory.createForClass(Spot);
