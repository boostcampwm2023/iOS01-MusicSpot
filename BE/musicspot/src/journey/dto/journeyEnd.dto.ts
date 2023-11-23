import { ApiProperty } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsNumber,
  IsString,
} from 'class-validator';

export class EndJourneyDTO {
  @ApiProperty({
    example: '655efda2fdc81cae36d20650',
    description: '여정 id',
    required: true,
  })
  @IsString()
  readonly _id: string;

  //   @IsString()
  //   readonly timestamp: string;
}
