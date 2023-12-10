import { ApiProperty } from '@nestjs/swagger';
import { IsArray, IsDateString, IsString, IsUrl } from 'class-validator';
import { IsCoordinate } from '../../common/decorator/coordinate.decorator';
import { IsObjectId } from 'src/common/decorator/objectId.decorator';

export class RecordSpotReqDTO {
  @ApiProperty({
    example: '655efda2fdc81cae36d20650',
    description: '여정 id',
    required: true,
  })
  @IsObjectId({ message: 'ObjectId 형식만 유효합니다.' })
  readonly journeyId: string;

  @ApiProperty({
    example: [37.555946, 126.972384],
    description: '위치 좌표',
    required: true,
  })
  @IsCoordinate({
    message:
      '위치 좌표는 2개의 숫자와 각각의 범위를 만족해야합니다.(-90~90 , -180~180)',
  })
  readonly coordinate: number[];

  @ApiProperty({
    example: '2023-11-22T12:00:00Z',
    description: 'timestamp',
    required: true,
  })
  @IsDateString()
  readonly timestamp: string;

  // @ApiProperty({
  //   example: 'base64-encoded-binary-image-data', // Update this with a valid base64-encoded image data
  //   description: 'Buffer',
  //   required: true,
  // })
  // readonly photoData: Buffer;
}

export class RecordSpotResDTO {
  @ApiProperty({
    example: '655efda2fdc81cae36d20650',
    description: '여정 id',
    required: true,
  })
  @IsString()
  readonly journeyId: string;

  @ApiProperty({
    example: [37.555946, 126.972384],
    description: '위치 좌표',
    required: true,
  })
  @IsArray()
  readonly coordinate: number[];

  @ApiProperty({
    example: '2023-11-22T12:00:00Z',
    description: 'timestamp',
    required: true,
  })
  @IsDateString()
  readonly timestamp: string;

  @ApiProperty({
    example:
      'https://music-spot-storage.kr.object.ncloudstorage.com/path/name?AWSAccessKeyId=key&Expires=1701850233&Signature=signature',
    description: 'presigned url',
    required: true,
  })
  @IsUrl()
  readonly photoUrl: string;
}
