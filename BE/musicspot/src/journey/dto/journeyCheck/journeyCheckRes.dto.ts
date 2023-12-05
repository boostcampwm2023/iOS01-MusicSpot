import { ApiProperty } from '@nestjs/swagger';

export class JourneyDTO {
  @ApiProperty({ description: '여정 ID', example: '65649c91380cafcab8869ed2' })
  readonly _id: string;

  @ApiProperty({ description: '여정 제목', example: '여정 제목' })
  readonly title: string;

  @ApiProperty({ description: 'spot 배열', example: [] })
  readonly spots: string[];

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

export class CheckJourneyResponseDTO {
  @ApiProperty({
    type: [JourneyDTO],
    description: '여정 데이터 배열',
  })
  readonly journeys: JourneyDTO[];
}
