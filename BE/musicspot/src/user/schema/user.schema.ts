import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

export type UserDocument = HydratedDocument<User>;

@Schema({ collection: 'user' })
export class User {
  @Prop()
  email: string;

  @Prop()
  nickname: string;

  @Prop()
  journeys: string[];
}

export const UserSchema = SchemaFactory.createForClass(User);
