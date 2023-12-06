import { ApiProperty } from '@nestjs/swagger';
import {
  IsString,
  IsDateString,
  IsDefined,
  ValidateNested,
  IsNumber,
} from 'class-validator';
import { Type } from 'class-transformer';
import { IsCoordinate } from '../../../common/decorator/coordinate.decorator';
import { SongDTO } from '../song/song.dto';

export class EndJourneyResponseDTO {
  @ApiProperty({
    example: '655efda2fdc81cae36d20650',
    description: '여정 id',
    required: true,
  })
  @IsString()
  readonly journeyId: string;

  @ApiProperty({
    example: [37.674986, 126.776032],
    description: '마지막 기록 위치',
    required: true,
  })
  @IsCoordinate()
  readonly coordinate: number[];

  @ApiProperty({
    example: '2023-11-22T15:30:00.000+09:00',
    description: '여정 종료 시간',
    required: true,
  })
  @IsDateString()
  endTimestamp: string;

  @ApiProperty({
    example: 10,
    description: '기록된 coordinate 수',
    required: true,
  })
  @IsNumber()
  readonly numberOfCoordinates: number;

  @ApiProperty({
    example: {
      id: '1',
      name: '655efda2fdc81cae36d20650',
      artistName: 'newjeans',
      artwork: {
        width: 3000,
        height: 3000,
        url: 'https://is3-ssl.mzstatic.com/image/thumb/Music125/v4/0b/b2/52/0bb2524d-ecfc-1bae-9c1e-218c978d7072/Honeymoon_3K.jpg/{w}x{h}bb.jpg',
        bgColor: '202020',
        textColor1: 'aea6f6',
        textColor2: 'b68ef6',
        textColor3: '918bcb',
        textColor4: '9878cb',
      },
    },
    description: '노래 정보',
    required: true,
  })
  @ValidateNested({ each: true })
  @Type(() => SongDTO)
  @IsDefined()
  readonly song: SongDTO;
}
