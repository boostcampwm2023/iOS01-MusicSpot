import { ApiProperty } from '@nestjs/swagger';
import { journeyMetadataDto, SpotDTO } from '../journeyCheck/journeyCheck.dto';
import { SpotV2DTO } from '../../../spot/dto/v2/spot.dto';
import { SongDTO } from '../song/song.dto';

export class JourneyV2DTO {
  @ApiProperty({ description: '여정 ID', example: '65649c91380cafcab8869ed2' })
  readonly journeyId: string;

  @ApiProperty({ description: '여정 제목', example: '여정 제목' })
  readonly title: string;

  @ApiProperty({
    example: '37.555946 126.972384,37.555946 126.972384',
    description: '위치 좌표',
    required: true,
  })
  readonly coordinates: string;

  @ApiProperty({ description: '여정 메타데이터', type: journeyMetadataDto })
  readonly journeyMetadata: journeyMetadataDto;

  @ApiProperty({ type: SpotV2DTO, description: 'spot 배열', isArray: true })
  readonly spots: SpotV2DTO[];

  @ApiProperty({ type: SongDTO, description: '여정 대표 음악' })
  readonly song: SongDTO;
}

//
