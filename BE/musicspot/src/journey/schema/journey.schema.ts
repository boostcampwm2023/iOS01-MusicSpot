import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';
import { ApiProperty } from '@nestjs/swagger';
export type JourneyDocument = HydratedDocument<Journey>;

@Schema({ collection: 'journey' })
export class Journey {
  @ApiProperty({
    example: 'test title',
    description: '여정 제목',
    required: true,
  })
  @Prop()
  title: string;

  @ApiProperty({
    example: [
      '655efda2fdc81cae36d20650',
      '655efd902908e4514ae5ff9b',
      '655efd27a08c7995defc8e91',
    ],
    description: 'spot id 배열',
    required: true,
  })
  @Prop()
  spots: string[];

  @ApiProperty({
    example: [
      [37.674986, 126.776032],
      [37.555946, 126.972384],
    ],
    description: '위치 좌표 배열',
    required: true,
  })
  @Prop({ type: [[Number]] })
  coordinates: number[][];

  @ApiProperty({
    example: '2023-11-22T15:30:00.000+09:00',
    description: '여정 시작 시간',
    required: true,
  })
  @Prop({ type: String })
  startTime: string;

  @ApiProperty({
    example: '2023-11-22T16:30:00.000+09:00',
    description: '여정 종료 시간',
    required: true,
  })
  @Prop({ type: String })
  endTime: string;

  // @Prop({ type: String })
  // timestamp: string;
}

export const JourneySchema = SchemaFactory.createForClass(Journey);
