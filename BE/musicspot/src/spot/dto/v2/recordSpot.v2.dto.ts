import { ApiProperty } from '@nestjs/swagger';
import { IsDateString, IsNumber } from 'class-validator';
import { IsCoordinateV2 } from '../../../common/decorator/coordinate.v2.decorator';

export class RecordSpotReqDTOV2 {
  @ApiProperty({
    example: '20',
    description: '여정 id',
    required: true,
  })
  @IsNumber()
  readonly journeyId: number;

  @ApiProperty({
    example: '37.555946 126.972384',
    description: '위치 좌표',
    required: true,
  })
  @IsCoordinateV2({
    message:
      '위치 좌표는 2개의 숫자와 각각의 범위를 만족해야합니다.(-90~90 , -180~180)',
  })
  readonly coordinate: string;

  @ApiProperty({
    example: '2023-11-22T12:00:00Z',
    description: 'timestamp',
    required: true,
  })
  @IsDateString()
  readonly timestamp: string;
}

export class RecordSpotResDTOV2 {
  @ApiProperty({
    example: 20,
    description: '여정 id',
    required: true,
  })
  readonly journeyId: number;

  @ApiProperty({
    example: '37.555946 126.972384',
    description: '위치 좌표',
    required: true,
  })
  readonly coordinate: string;

  @ApiProperty({
    example: '2023-11-22T12:00:00Z',
    description: 'timestamp',
    required: true,
  })
  readonly timestamp: string;

  @ApiProperty({
    example:
      'https://music-spot-storage.kr.object.ncloudstorage.com/path/name?AWSAccessKeyId=key&Expires=1701850233&Signature=signature',
    description: 'presigned url',
    required: true,
  })
  readonly photoUrl: string;
}
