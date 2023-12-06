import { ApiProperty } from '@nestjs/swagger';
import {
  IsString,
  IsDateString,
  ValidateNested,
  IsDefined,
  IsNumber,
} from 'class-validator';
import { IsCoordinate } from '../../../common/decorator/coordinate.decorator';
import { Type } from 'class-transformer';
import { SongDTO } from '../song/song.dto';

export class EndJourneyReqDTO {
  @ApiProperty({
    example: '655efda2fdc81cae36d20650',
    description: '여정 id',
    required: true,
  })
  @IsString()
  readonly journeyId: string;

  @ApiProperty({
    example: [
      [37.555946, 126.972384],
      [37.555946, 126.972384],
    ],
    description: '위치 좌표',
    required: true,
  })
  @IsCoordinate({
    message: '배열의 각 요소는 양수여야 하고 두 개의 요소만 허용됩니다.',
  })
  readonly coordinates: number[][];

  @ApiProperty({
    example: '2023-11-22T12:00:00Z',
    description: 'timestamp',
    required: true,
  })
  @IsDateString()
  readonly endTimestamp: string;

  @ApiProperty({
    example: '여정 제목',
    description: '여정 제목',
    required: true,
  })
  @IsString()
  readonly title: string;

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
  @ValidateNested()
  @Type(() => SongDTO)
  @IsDefined()
  readonly song: SongDTO;
}

export class EndJourneyResDTO {
  @ApiProperty({
    example: '655efda2fdc81cae36d20650',
    description: '여정 id',
    required: true,
  })
  @IsString()
  readonly journeyId: string;

  @ApiProperty({
    example: [
      [37.555946, 126.972384],
      [37.555946, 126.972384],
    ],
    description: '마지막 위치 기록',
    required: true,
  })
  @IsCoordinate()
  readonly coordinates: number[][];

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
