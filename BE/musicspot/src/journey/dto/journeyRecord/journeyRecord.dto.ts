import { ApiProperty } from '@nestjs/swagger';
import { IsString } from 'class-validator';
import { IsCoordinate } from '../../../common/decorator/coordinate.decorator';
export class RecordJourneyResDTO {
  @ApiProperty({
    example: [
      [37.555946, 126.972384],
      [37.555946, 126.972384],
    ],
    description: '저장된 위치 좌표',
    required: true,
  })
  readonly coordinates: number[][];
}

export class RecordJourneyReqDTO {
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
  readonly coordinates: number[][];
}
