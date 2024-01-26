import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsDateString, IsArray, IsUUID } from 'class-validator';
import { IsCoordinate } from '../../../common/decorator/coordinate.decorator';
import { UUID } from 'crypto';

export class StartJourneyReqDTO {
  @ApiProperty({
    example: 'ab4068ef-95ed-40c3-be6d-3db35df866b9',
    description: '사용자 id',
    required: true,
  })
  @IsUUID()
  readonly userId: UUID;
  
  @ApiProperty({
    example: [37.555946, 126.972384],
    description: '위치 좌표',
    required: true,
  })
  @IsCoordinate({
    message:
      '위치 좌표는 2개의 숫자와 각각의 범위를 만족해야합니다.(-90~90 , -180~180)',
  })
  readonly coordinate: number[];

  @ApiProperty({
    example: '2023-11-22T12:00:00Z',
    description: '시작 timestamp',
    required: true,
  })
  @IsDateString()
  readonly startTimestamp: string;

  
}

export class StartJourneyResDTO {
  @ApiProperty({
    example: 20,
    description: '저장한 journey id',
  })
  readonly journeyId: number;

  @ApiProperty({
    example: [37.555946, 126.972384],
    description: '위치 좌표',
  })
  readonly coordinate:number[];

  @ApiProperty({
    example: '2023-11-22T12:00:00Z',
    description: 'timestamp',
  })
  readonly startTimestamp: string;

}
 
