import { ApiProperty } from '@nestjs/swagger';
import { IsNumber, IsString, IsUrl } from 'class-validator';

export class ArtworkDTO {
  @ApiProperty({
    example: 3000,
    description: '앨범 커버 이미지 넓이',
    required: true,
  })
  @IsNumber()
  width: number;

  @ApiProperty({
    example: 3000,
    description: '앨범 커버 이미지 높이',
    required: true,
  })
  @IsNumber()
  height: number;

  @ApiProperty({
    example:
      'https://is3-ssl.mzstatic.com/image/thumb/Music125/v4/0b/b2/52/0bb2524d-ecfc-1bae-9c1e-218c978d7072/Honeymoon_3K.jpg/{w}x{h}bb.jpg',
    description: '앨범 커버 이미지 URL',
    required: true,
  })
  @IsUrl()
  url: URL;

  @ApiProperty({
    example: 3000,
    description: '배경 컬러',
    required: true,
  })
  @IsString()
  bgColor: string;

  @ApiProperty({
    example: 3000,
    description: '텍스트 컬러1',
    required: true,
  })
  @IsString()
  textColor1: string;

  @ApiProperty({
    example: 3000,
    description: '텍스트 컬러2',
    required: true,
  })
  @IsString()
  textColor2: string;

  @ApiProperty({
    example: 3000,
    description: '텍스트 컬러3',
    required: true,
  })
  @IsString()
  textColor3: string;

  @ApiProperty({
    example: 3000,
    description: '텍스트 컬러4',
    required: true,
  })
  @IsString()
  textColor4: string;
}
