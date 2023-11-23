import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsNumber,
  IsString,
} from 'class-validator';

export class EndJourneyDTO {
  @IsString()
  readonly _id: string;

  //   @IsString()
  //   readonly timestamp: string;
}
