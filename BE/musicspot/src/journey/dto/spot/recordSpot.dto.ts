import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsDateString, IsNumber, IsObject } from 'class-validator';
import { UUID } from 'crypto';
import { IsCoordinateV2 } from '../../../common/decorator/coordinate.v2.decorator';
export class RecordSpotReqDTO {
  @ApiProperty({
    example: '37.555941 126.972381',
    description: 'spot 위치',
    required: true,
  })
  @IsCoordinateV2()
  readonly coordinate: string;

  @ApiProperty({
    example: '2023-11-22T12:00:56Z',
    description: 'spot 기록 시간',
    required: true,
  })
  @IsString()
  readonly timestamp: string;


  @ApiProperty({
    example: 'song object',
    description: 'spot 기록 시간',
  })
  @IsObject()
  readonly spotSong: object;
}

export class RecordSpotResDTO {
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
  readonly photoUrls: string[];
}
