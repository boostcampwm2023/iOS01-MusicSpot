import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';
import { ApiProperty } from '@nestjs/swagger';
import { Song } from './song.schema';
import { JourneyMetadata } from './journeyMetadata.schema';
import { IsDefined, ValidateNested } from 'class-validator';

export type JourneyDocument = HydratedDocument<Journey>;

@Schema({ collection: 'journey' })
export class Journey {
  @ApiProperty({
    example: 'test title',
    description: '여정 제목',
    required: true,
  })
  @Prop()
  title?: string;

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
  spots?: string[];

  @ApiProperty({
    example: [
      [37.674986, 126.776032],
      [37.555946, 126.972384],
    ],
    description: '위치 좌표 배열',
    required: true,
  })
  @Prop({ type: [[Number]] })
  coordinates?: number[][];

  @ApiProperty({ description: '메타데이터', type: JourneyMetadata })
  @Prop({ type: JourneyMetadata })
  journeyMetadata?: JourneyMetadata;

  @ApiProperty({ description: '음악 정보', type: Song })
  @Prop({ type: Song })
  song?: Song;
}

export const JourneySchema = SchemaFactory.createForClass(Journey);
