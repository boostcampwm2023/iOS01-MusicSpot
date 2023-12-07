import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsDateString } from 'class-validator';
import { IsCoordinate } from '../../../common/decorator/coordinate.decorator';
import { UUID } from 'crypto';
export class StartJourneyReqDTO {
  @ApiProperty({
    example: [37.555946, 126.972384],
    description: '위치 좌표',
    required: true,
  })
  @IsCoordinate({
    message: '배열의 각 요소는 양수여야 하고 두 개의 요소만 허용됩니다.',
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
    example: 'ab4068ef-95ed-40c3-be6d-3db35df866b9',
    description: '사용자 id',
    required: true,
  })
  @IsString()
  readonly userId: UUID;

  // @ApiProperty({
  //   example: 'hello@gmail.com',
  //   description: '이메일',
  //   required: true,
  // })
  // @IsString()
  // readonly email: string;
}

export class StartJourneyResDTO {
  @ApiProperty({
    example: [37.555946, 126.972384],
    description: '위치 좌표',
    required: true,
  })
  @IsCoordinate({
    message: '배열의 각 요소는 양수여야 하고 두 개의 요소만 허용됩니다.',
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

  // @ApiProperty({
  //   example: 'hello@gmail.com',
  //   description: '이메일',
  //   required: true,
  // })
  // @IsString()
  // readonly email: string;
}