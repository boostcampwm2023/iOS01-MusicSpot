import { ApiProperty } from '@nestjs/swagger';
import {
  IsString,
  IsDateString,
  ValidateNested,
  IsDefined,
  IsNumber,
  IsArray,
  IsObject,
} from 'class-validator';
import {
  IsCoordinate,
  IsCoordinates,
} from '../../../common/decorator/coordinate.decorator';
import { Type } from 'class-transformer';
import { SongDTO } from '../song/song.dto';



export class EndJourneyReqDTO {
  @ApiProperty({
    example: 20,
    description: '여정 id',
    required: true,
  })
  // @IsObjectId({ message: 'ObjectId 형식만 유효합니다.' })
  @IsNumber()
  readonly journeyId: number;

  @ApiProperty({
    example: [
      [37.555946, 126.972384],
      [37.555946, 126.972384],
    ],
    description: '위치 좌표',
    required: true,

  })
  @IsCoordinates({
    message:
      '위치 좌표 배열은 2차원 배열이고 각각의 배열은 숫자 2개와 범위를 만족해야합니다.(-90~90, -180~180)',
  })
  readonly coordinates: number[][];

  @ApiProperty({
    example: '2023-11-22T12:00:00Z',
    description: '종료 timestamp',
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

  @IsObject()
  @ApiProperty({
    description: '노래 정보',
    required: true,
  })
  readonly song: object;
}

export class EndJourneyResDTO {
  @ApiProperty({
    example: 20,
    description: '여정 id',
    required: true,
  })
  @IsString()
  readonly journeyId: number;

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
    description: '노래 정보',
    required: true,
  })
  readonly song: Object;
}
