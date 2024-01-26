import { ApiProperty } from '@nestjs/swagger';
import { IsNumber} from 'class-validator';
import {
  IsCoordinates,
} from '../../../common/decorator/coordinate.decorator';

export class RecordJourneyReqDTO {
  @ApiProperty({
    example: 20,
    description: '여정 id',
    required: true,
  })
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
}


export class RecordJourneyResDTO {
  @ApiProperty({
    example: [
      [37.555946, 126.972384],
      [37.555946, 126.972384],
    ],
    description: '저장된 위치 좌표',
    required: true,
  })
  @IsCoordinates()
  readonly coordinates: number[][];
}


