import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsDateString } from 'class-validator';
import { UUID } from 'crypto';

export class SpotDTO {
  @ApiProperty({ description: '여정 ID', example: '65649c91380cafcab8869ed2' })
  readonly journeyId: string;

  @ApiProperty({ description: 'spot 위치', example: [37.555913, 126.972313] })
  readonly coordinate: number[];

  @ApiProperty({ description: '기록 시간', example: '2023-11-22T12:00:00Z' })
  readonly timestamp: string;

  @ApiProperty({
    description: 'presigned url',
    example:
      'https://music-spot-storage.kr.object.ncloudstorage.com/path/name?AWSAccessKeyId=key&Expires=sec&Signature=signature',
  })
  readonly photoUrl: string;
}

class journeyMetadataDto {
  @ApiProperty({
    description: '여정 시작 시간',
    example: '2023-11-22T15:30:00.000+09:00',
  })
  readonly startTimestamp: string;

  @ApiProperty({
    description: '여정 종료 시간',
    example: '2023-11-22T15:30:00.000+09:00',
  })
  readonly endTimestamp: string;
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

  @ApiProperty({ description: '여정 메타데이터', type: journeyMetadataDto })
  readonly journeyMetadata: journeyMetadataDto;
}

export class LastJourneyResDTO {
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

  @ApiProperty({ description: '여정 메타데이터', type: journeyMetadataDto })
  readonly journeyMetadata: journeyMetadataDto;

  @ApiProperty({ description: '여정 마무리 여부' })
  readonly isRecording: boolean;
}
