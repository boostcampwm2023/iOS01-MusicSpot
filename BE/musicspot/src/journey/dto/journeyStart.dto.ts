import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsNumber,
  IsString,
} from 'class-validator';

export class StartJourneyDTO {
  @IsString()
  readonly title: string;

  @IsArray()
  @ArrayMaxSize(2, { message: 'coordinate has only 2' })
  @ArrayMinSize(2, { message: 'coordinate has only 2' })
  @IsNumber({}, { each: true })
  readonly coordinate: number[];

  @IsString()
  readonly timestamp: string;

  @IsString()
  readonly email: string;
}
