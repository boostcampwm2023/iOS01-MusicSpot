import { ApiProperty } from '@nestjs/swagger';
import { IsDateString, IsString } from 'class-validator';
import { IsCoordinateV2 } from '../../../common/decorator/coordinate.v2.decorator';
import { SongDTO } from '../../../journey/dto/song/song.dto';

export class RecordSpotReqDTOV2 {
  @ApiProperty({
    example: '37.555946 126.972384',
    description: '위치 좌표',
    required: true,
  })
  @IsCoordinateV2({
    message:
      '위치 좌표는 2개의 숫자와 각각의 범위를 만족해야합니다.(-90~90 , -180~180)',
  })
  readonly coordinate: string;

  @ApiProperty({
    example: '2023-11-22T12:00:00Z',
    description: 'timestamp',
    required: true,
  })
  @IsDateString()
  readonly timestamp: string;

  @IsString()
  readonly spotSong: string;
}

const spotSongEx = {
  id: '655efda2fdc81cae36d20650',
  name: 'super shy',
  artistName: 'newjeans',
  artwork: {
    width: 3000,
    height: 3000,
    url: 'https://is3-ssl.mzstatic.com/image/thumb/Music125/v4/0b/b2/52/0bb2524d-ecfc-1bae-9c1e-218c978d7072/Honeymoon_3K.jpg/{w}x{h}bb.jpg',
    bgColor: '3000',
  },
};
export class Photo {
  @ApiProperty({
    description: 'photo Id',
    example: '20',
  })
  readonly photoId: number;

  @ApiProperty({
    description: 'photo presigned url',
    example:
      'https://music-spot-test.kr.object.ncloudstorage.com/52/17083469749660?AWSAccessKeyId=194C0D972294FBAFCE35&Expires=1708347035&Signature=29GAH%2Fl1BcsTkYof5BUqcXPRPVU%3D',
  })
  readonly photoUrl: string;
}
export class RecordSpotResDTOV2 {
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
    example:
      'https://music-spot-storage.kr.object.ncloudstorage.com/path/name?AWSAccessKeyId=key&Expires=1701850233&Signature=signature',
    description: 'photo key(V1만 유효)',
  })
  readonly photoUrl: string;

  @ApiProperty({
    description: 'spot 별 음악(V2)',
    type: SongDTO,
  })
  readonly spotSong;

  @ApiProperty({
    description: 'photo의 url 모음',
    type: Photo,
    isArray: true,
  })
  readonly photos: Photo[];
}
