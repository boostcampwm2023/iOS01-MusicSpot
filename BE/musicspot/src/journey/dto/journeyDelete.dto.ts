import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsDateString, IsNumber } from 'class-validator';
import { UUID } from 'crypto';
export class DeleteJourneyReqDTO {
  @ApiProperty({
    example: 'ab4068ef-95ed-40c3-be6d-3db35df866b9',
    description: '사용자 id',
    required: true,
  })
  @IsString()
  readonly userId: UUID;

  @ApiProperty({
    example: '6574c8adb08b3d712827385f',
    description: '여정 id',
    required: true,
  })
  @IsNumber()
  readonly journeyId: number;
}

export class DeleteJourneyResDTO {
  @ApiProperty({
    example: [37.555946, 126.972384],
    description: '위치 좌표',
    required: true,
  })
  readonly coordinate: number[];

  @ApiProperty({
    example: '2023-11-22T12:00:00Z',
    description: 'timestamp',
    required: true,
  })
  @IsDateString()
  readonly startTimestamp: string;

  @ApiProperty({
    example: '656f4b55b11c27334d1fd347',
    description: '저장한 journey id',
    required: true,
  })
  @IsString()
  readonly journeyId: string;
}
