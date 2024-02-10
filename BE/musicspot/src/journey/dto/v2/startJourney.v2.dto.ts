import { ApiProperty } from '@nestjs/swagger';
import { IsDateString, IsUUID } from 'class-validator';
import { UUID } from 'crypto';

export class StartJourneyReqDTOV2 {
  @ApiProperty({
    example: 'ab4068ef-95ed-40c3-be6d-3db35df866b9',
    description: '사용자 id',
    required: true,
  })
  @IsUUID()
  readonly userId: UUID;

  @ApiProperty({
    example: '2023-11-22T12:00:00Z',
    description: '시작 timestamp',
    required: true,
  })
  @IsDateString()
  readonly startTimestamp: string;
}

export class StartJourneyResDTOV2 {
  @ApiProperty({
    example: 20,
    description: '저장한 journey id',
  })
  readonly journeyId: number;

  @ApiProperty({
    example: '2023-11-22T12:00:00Z',
    description: 'timestamp',
  })
  readonly startTimestamp: string;
}
