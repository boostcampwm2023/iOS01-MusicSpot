import { ApiProperty } from '@nestjs/swagger';
import { IsString } from 'class-validator';

export class journeyMetadataDTO {
  @ApiProperty({
    example: '2023-11-22T15:30:00.000+09:00',
    description: '여정 시작 시간',
    required: true,
  })
  @IsString()
  startTimestamp: string;

  @ApiProperty({
    example: '2023-11-22T15:30:00.000+09:00',
    description: '여정 종료 시간',
    required: true,
  })
  @IsString()
  endTimestamp: string;
}
