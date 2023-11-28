import { ApiProperty } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsNumber,
  IsString,
} from 'class-validator';
import { IsCoordinate } from '../../common/decorator/coordinate.decorator';
export class StartJourneyDTO {
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
  @IsString()
  readonly timestamp: string;

  @ApiProperty({
    example: 'hello@gmail.com',
    description: '이메일',
    required: true,
  })
  @IsString()
  readonly email: string;
}
