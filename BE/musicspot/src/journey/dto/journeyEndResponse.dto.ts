import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsDateString, IsArray, IsNotEmpty } from 'class-validator';
import { IsCoordinate } from '../../common/decorator/coordinate.decorator';
export class EndJourneyResponseDTO {
  @ApiProperty({
    example: '655efda2fdc81cae36d20650',
    description: '여정 id',
    required: true,
  })
  @IsString()
  readonly journeyId: string;
  @ApiProperty({
    example: '여정 제목',
    description: '여정 제목',
    required: true,
  })
  @IsString()
  readonly title: string;

  @IsString({ each: true })
  @IsNotEmpty()
  @ApiProperty({
    example: [
      '655efda2fdc81cae36d20650',
      '655efd902908e4514ae5ff9b',
      '655efd27a08c7995defc8e91',
    ],
    description: 'spot id 배열',
    required: true,
  })
  readonly spots: string[];

  @IsArray()
  @IsNotEmpty()
  @ApiProperty({
    example: [
      [37.674986, 126.776032],
      [37.555946, 126.972384],
    ],
    description: '위치 좌표 배열',
    required: true,
  })
  readonly coordinates: number[][];

  @IsDateString()
  readonly endTime: string;
}
