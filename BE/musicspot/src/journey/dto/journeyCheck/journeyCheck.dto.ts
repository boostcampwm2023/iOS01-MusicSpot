import { ApiProperty } from '@nestjs/swagger';
import { IsArray, IsNotEmpty, IsUUID } from 'class-validator';
import { UUID } from 'crypto';
import { IsCoordinate } from 'src/common/decorator/coordinate.decorator';

export class CheckJourneyReqDTO {
  @IsNotEmpty()
  @ApiProperty({
    example: 'ACB46D2C-44D7-444F-84C5-4EF7E81E12E',
    description: '유저 id',
    required: true,
  })
  @IsUUID()
  readonly userId: UUID;

  // @IsCoordinate({
  //   message: '배열의 각 요소는 양수여야 하고 두 개의 요소만 허용됩니다.',
  // })
  @ApiProperty({
    example: [37.555946, 126.972384],
    description: '위치 좌표',
    required: true,
  })
  @IsNotEmpty()
  @IsCoordinate({
    message:
      '위치 좌표는 2개의 숫자와 각각의 범위를 만족해야합니다.(-90~90 , -180~180)',
  })
  readonly minCoordinate: number[];

  @ApiProperty({
    example: [37.555946, 126.972384],
    description: '위치 좌표',
    required: true,
  })
  @IsNotEmpty()
  @IsArray()
  readonly maxCoordinate: number[];
}

export class SpotDTO {
  @ApiProperty({ description: '여정 ID', example: '65649c91380cafcab8869ed2' })
  readonly journeyId: string;

  @ApiProperty({ description: 'spot 위치', example: '37.555913 126.972313' })
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

export class CheckJourneyResDTO {
  @ApiProperty({
    type: [JourneyDTO],
    description: '여정 데이터 배열',
  })
  readonly journeys: JourneyDTO[];
}
