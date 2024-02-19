import { ApiProperty } from '@nestjs/swagger';

export class PhotoDTO {
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
