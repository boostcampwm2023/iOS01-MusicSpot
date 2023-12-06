import { Prop } from '@nestjs/mongoose';
import { ApiProperty } from '@nestjs/swagger';

export class Artwork {
  @ApiProperty({
    example: 3000,
    description: '앨범 커버 이미지 넓이',
    required: true,
  })
  @Prop()
  width: number;

  @ApiProperty({
    example: 3000,
    description: '앨범 커버 이미지 높이',
    required: true,
  })
  @Prop()
  height: number;

  @ApiProperty({
    example:
      'https://is3-ssl.mzstatic.com/image/thumb/Music125/v4/0b/b2/52/0bb2524d-ecfc-1bae-9c1e-218c978d7072/Honeymoon_3K.jpg/{w}x{h}bb.jpg',
    description: '앨범 커버 이미지 URL',
    required: true,
  })
  @Prop()
  url: URL;

  @ApiProperty({
    example: 3000,
    description: '배경 컬러',
    required: true,
  })
  @Prop()
  bgColor: string;

  @ApiProperty({
    example: 3000,
    description: '텍스트 컬러1',
    required: true,
  })
  @Prop()
  textColor1: string;

  @ApiProperty({
    example: 3000,
    description: '텍스트 컬러2',
    required: true,
  })
  @Prop()
  textColor2: string;

  @ApiProperty({
    example: 3000,
    description: '텍스트 컬러3',
    required: true,
  })
  @Prop()
  textColor3: string;

  @ApiProperty({
    example: 3000,
    description: '텍스트 컬러4',
    required: true,
  })
  @Prop()
  textColor4: string;
}