import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { UUID } from 'crypto';
import { HydratedDocument } from 'mongoose';
import { ApiProperty } from '@nestjs/swagger';
export type UserDocument = HydratedDocument<User>;

@Schema({ collection: 'user' })
export class User {
  @ApiProperty({
    example: 'ab4068ef-95ed-40c3-be6d-3db35df866b9',
    description: '유저 id(UUID)',
    uniqueItems: true,
    required: true,
  })
  @Prop()
  userId: UUID;

  @ApiProperty({
    example: [],
    description: 'journey id 리스트(생성 시에는 빈 배열입니다.)',
    required: true,
  })
  @Prop()
  journeys: string[];

  // @Prop()
  // email: string;

  // @Prop()
  // nickname: string;
}

export const UserSchema = SchemaFactory.createForClass(User);
