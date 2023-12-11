import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';
import { IsCoordinate } from 'src/common/decorator/coordinate.decorator';

export class LoadJourneyDTO {
  @IsNotEmpty()
  @ApiProperty({
    example: '655efda2fdc81cae36d20650',
    description: '유저 id',
    required: true,
  })
  @IsString()
  readonly userId: string;
}
