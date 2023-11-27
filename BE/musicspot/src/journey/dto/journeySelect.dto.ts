import { ApiProperty } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsNumber,
  IsString,
} from 'class-validator';

export class SelectJourneyDTO {
  @ApiProperty({
    example: [37.555946, 126.972384],
    description: '위치 좌표',
    required: true,
  })
  @IsArray()
  @ArrayMaxSize(2, { message: 'coordinate has only 2' })
  @ArrayMinSize(2, { message: 'coordinate has only 2' })
  @IsNumber({}, { each: true })
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
