import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';
import { IsCoordinate } from 'src/common/decorator/coordinate.decorator';

export class CheckJourneyDTO {
  @IsNotEmpty()
  @ApiProperty({
    example: '655efda2fdc81cae36d20650',
    description: '유저 id',
    required: true,
  })
  @IsString()
  readonly userId: string;

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
