import { ApiProperty } from '@nestjs/swagger';
import { IsDefined, IsString, ValidateNested } from 'class-validator';
import { ArtworkDTO } from './artwork.dto';
import { Type } from 'class-transformer';
export class SongDTO {
  @ApiProperty({
    example: '655efda2fdc81cae36d20650',
    description: '노래 ID',
    required: true,
  })
  @IsString()
  id: string;

  @ApiProperty({
    example: 'super shy',
    description: '노래 제목',
    required: true,
  })
  @IsString()
  name: string;

  @ApiProperty({
    example: 'newjeans',
    description: '가수',
    required: true,
  })
  @IsString()
  artistName: string;

  @ApiProperty({
    example: {
      width: 3000,
      height: 3000,
      url: 'https://is3-ssl.mzstatic.com/image/thumb/Music125/v4/0b/b2/52/0bb2524d-ecfc-1bae-9c1e-218c978d7072/Honeymoon_3K.jpg/{w}x{h}bb.jpg',
      bgColor: '202020',
      textColor1: 'aea6f6',
      textColor2: 'b68ef6',
      textColor3: '918bcb',
      textColor4: '9878cb',
    },
    description: 'artwork 관련 정보',
    required: true,
  })
  @ValidateNested({ each: true })
  @Type(() => ArtworkDTO)
  @IsDefined()
  artwork: ArtworkDTO;
}
