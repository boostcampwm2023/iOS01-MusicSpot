import { ApiProperty } from '@nestjs/swagger';
import {
  IsString,
  IsDateString,
  IsArray,
  IsNotEmpty,
  ValidateNested,
  IsNumber,
} from 'class-validator';

import { IsCoordinate } from '../../../common/decorator/coordinate.decorator';
import { Song } from '../../schema/song.schema';

export class EndJourneyResponseDTO {
  @ApiProperty({
    example: [37.674986, 126.776032],
    description: '마지막 기록 위치',
    required: true,
  })
  @IsCoordinate()
  readonly coordinate: number[];

  @ApiProperty({
    example: '2023-11-22T15:30:00.000+09:00',
    description: '여정 종료 시간',
    required: true,
  })
  @IsString()
  endTimestamp: string;

  @ApiProperty({
    example: '655efda2fdc81cae36d20650',
    description: '여정 id',
    required: true,
  })
  @IsString()
  readonly journeyId: string;

  @ApiProperty({
    example: 10,
    description: '기록된 coordinate 수',
    required: true,
  })
  @IsNumber()
  readonly numberOfCoordinates: number;

  @ValidateNested()
  readonly song: Song;
}
