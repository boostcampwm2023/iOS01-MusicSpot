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
    type: ArtworkDTO,
    description: 'artwork 관련 정보',
    required: true,
  })
  @ValidateNested({ each: true })
  @Type(() => ArtworkDTO)
  artwork: ArtworkDTO;
}
