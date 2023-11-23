import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

export type SpotDocument = HydratedDocument<Spot>;

@Schema({ collection: 'spot' })
export class Spot {
  @Prop()
  journeyId: string;

  @Prop({ type: [Number] })
  coordinate: number[];

  @Prop({ type: String })
  timestamp: string;

  @Prop({ type: String })
  photoUrl: string;
}

export const SpotSchema = SchemaFactory.createForClass(Spot);
