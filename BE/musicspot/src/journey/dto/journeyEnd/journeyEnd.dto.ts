import { ApiProperty } from '@nestjs/swagger';
import {
  IsString,
  IsDateString,
  ValidateNested,
  IsDefined,
  IsNumber,
  IsArray,
} from 'class-validator';
import {
  IsCoordinate,
  IsCoordinates,
} from '../../../common/decorator/coordinate.decorator';
import { Type } from 'class-transformer';
import { SongDTO } from '../song/song.dto';

export class EndJourneyReqDTO {
  @ApiProperty({
    example: '655efda2fdc81cae36d20650',
    description: '여정 id',
    required: true,
  })
  @IsString()
  readonly journeyId: string;

  @ApiProperty({
    example: [
      [37.555946, 126.972384],
      [37.555946, 126.972384],
    ],
    description: '위치 좌표',
    required: true,
  })
  @IsCoordinates()
  readonly coordinates: number[][];

  @ApiProperty({
    example: '2023-11-22T12:00:00Z',
    description: 'timestamp',
    required: true,
  })
  @IsDateString()
  readonly endTimestamp: string;

  @ApiProperty({
    example: '여정 제목',
    description: '여정 제목',
    required: true,
  })
  @IsString()
  readonly title: string;

  @ApiProperty({
    type: SongDTO,
    description: '노래 정보',
    required: true,
  })
  @ValidateNested()
  @Type(() => SongDTO)
  @IsDefined()
  readonly song: SongDTO;
}

export class EndJourneyResDTO {
  @ApiProperty({
    example: '655efda2fdc81cae36d20650',
    description: '여정 id',
    required: true,
  })
  @IsString()
  readonly journeyId: string;

  @ApiProperty({
    example: [
      [37.555946, 126.972384],
      [37.555946, 126.972384],
    ],
    description: '마지막 위치 기록',
    required: true,
  })
  @IsArray()
  readonly coordinates: number[][];

  @ApiProperty({
    example: '2023-11-22T15:30:00.000+09:00',
    description: '여정 종료 시간',
    required: true,
  })
  @IsDateString()
  endTimestamp: string;

  @ApiProperty({
    example: 10,
    description: '기록된 coordinate 수',
    required: true,
  })
  @IsNumber()
  readonly numberOfCoordinates: number;

  @ApiProperty({
    type: SongDTO,
    description: '노래 정보',
    required: true,
  })
  @ValidateNested({ each: true })
  @Type(() => SongDTO)
  @IsDefined()
  readonly song: SongDTO;
}
