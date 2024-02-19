import { ApiProperty } from '@nestjs/swagger';
import { SongDTO } from '../../../journey/dto/song/song.dto';
import { PhotoDTO } from '../../../photo/dto/photo.dto';

export class SpotV2DTO {
  @ApiProperty({
    example: 20,
    description: 'spot id',
  })
  readonly spotId: number;

  @ApiProperty({
    example: 20,
    description: '여정 id',
    required: true,
  })
  readonly journeyId: number;

  @ApiProperty({
    example: '37.555946 126.972384',
    description: '위치 좌표',
    required: true,
  })
  readonly coordinate: string;

  @ApiProperty({
    example: '2023-11-22T12:00:00Z',
    description: 'timestamp',
    required: true,
  })
  readonly timestamp: string;

  @ApiProperty({
    example: null,
    description: 'photo key(V1만 유효)',
  })
  readonly photoKey: string;

  @ApiProperty({
    description: 'spot 별 음악(V2)',
    type: SongDTO,
  })
  readonly spotSong;

  @ApiProperty({
    description: 'photo의 url 모음',
    type: PhotoDTO,
    isArray: true,
  })
  readonly photos: PhotoDTO[];
}
