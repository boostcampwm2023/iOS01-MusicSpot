import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString, IsUUID } from 'class-validator';
import { UUID } from 'crypto';
import { IsCoordinate } from 'src/common/decorator/coordinate.decorator';

export class CheckJourneyReqDTO {
  @IsNotEmpty()
  @ApiProperty({
    example: '655efda2fdc81cae36d20650',
    description: '유저 id',
    required: true,
  })
  @IsUUID()
  readonly userId: UUID;

  @ApiProperty({
    example: [37.555946, 126.972384],
    description: '위치 좌표',
    required: true,
  })
  @IsNotEmpty()
  @IsCoordinate({
    message: '배열의 각 요소는 양수여야 하고 두 개의 요소만 허용됩니다.',
  })
  readonly minCoordinate: number[];
  @ApiProperty({
    example: [37.555946, 126.972384],
    description: '위치 좌표',
    required: true,
  })
  @IsNotEmpty()
  @IsCoordinate({
    message: '배열의 각 요소는 양수여야 하고 두 개의 요소만 허용됩니다.',
  })
  readonly maxCoordinate: number[];
}

export class SpotDTO {
  @ApiProperty({ description: 'spot ID', example: '65649c91380cafcab8869ed2' })
  readonly _id: string;

  @ApiProperty({ description: '여정 ID', example: '65649c91380cafcab8869ed2' })
  readonly journeyId: string;

  @ApiProperty({ description: 'spot 위치', example: [37.555913, 126.972313] })
  readonly coordinate: number[];

  @ApiProperty({ description: '기록 시간', example: '2023-11-22T12:00:00Z' })
  readonly timestamp: string;

  @ApiProperty({
    description: '파일 이름',
    example: '656f6d266f1175ab5d67e9fd/1701853125890',
  })
  readonly photoKey: string;
}
export class JourneyDTO {
  @ApiProperty({ description: '여정 ID', example: '65649c91380cafcab8869ed2' })
  readonly _id: string;

  @ApiProperty({ description: '여정 제목', example: '여정 제목' })
  readonly title: string;

  @ApiProperty({ type: [SpotDTO], description: 'spot 배열' })
  readonly spots: SpotDTO[];

  @ApiProperty({
    description: '위치 좌표 배열',
    example: [
      [37.775, 122.4195],
      [37.7752, 122.4197],
      [37.7754, 122.4199],
    ],
  })
  readonly coordinates: number[][];
}

export class CheckJourneyResDTO {
  @ApiProperty({
    type: [JourneyDTO],
    description: '여정 데이터 배열',
  })
  readonly journeys: JourneyDTO[];
}
