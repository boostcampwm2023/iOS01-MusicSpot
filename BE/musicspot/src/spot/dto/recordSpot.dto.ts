import { ApiProperty } from '@nestjs/swagger';
import { IsDateString, IsString } from 'class-validator';
import { IsCoordinate } from '../../common/decorator/coordinate.decorator';

export class RecordSpotDTO {
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
  @IsCoordinate({
    message: '배열의 각 요소는 양수여야 하고 두 개의 요소만 허용됩니다.',
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
