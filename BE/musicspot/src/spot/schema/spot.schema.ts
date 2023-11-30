import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { ApiProperty } from '@nestjs/swagger';
import { HydratedDocument } from 'mongoose';

export type SpotDocument = HydratedDocument<Spot>;

@Schema({ collection: 'spot' })
export class Spot {
  @ApiProperty({
    example: '655efda2fdc81cae36d20650',
    description: 'spot id 배열',
    required: true,
  })
  @Prop()
  journeyId: string;

  @ApiProperty({
    example: [37.674986, 126.776032],
    description: '위치 좌표 배열',
    required: true,
  })
  @Prop({ type: [Number] })
  coordinate: number[];
  @ApiProperty({
    example: '2023-11-22T15:30:00.000+09:00',
    description: '시작 시간',
    required: true,
  })
  @Prop({ type: String })
  timestamp: string;
  @ApiProperty({
    example: 'photo/url',
    description: '사진 URL',
    required: true,
  })
  @Prop({ type: String })
  photoUrl: string;
}

export const SpotSchema = SchemaFactory.createForClass(Spot);
