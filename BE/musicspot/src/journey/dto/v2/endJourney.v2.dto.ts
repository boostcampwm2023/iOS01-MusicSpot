import { ApiProperty } from '@nestjs/swagger';
import {
  IsString,
  IsDateString,
  IsNumber,
  IsObject,
} from 'class-validator';
import { IsCoordinatesV2 } from '../../../common/decorator/coordinate.v2.decorator';

export class EndJourneyReqDTOV2 {
  // @ApiProperty({
  //   example: 20,
  //   description: '여정 id',
  //   required: true,
  // })
  // @IsNumber()
  // readonly journeyId: number;

  @ApiProperty({
    example: '37.555946 126.972384,37.555946 126.972384',
    description: '위치 좌표',
    required: true,
  })
  @IsCoordinatesV2({
    message:
      '잘못된 coordinates 형식입니다. Ex) 37.555946 126.972384,37.555946 126.972384',
  })
  readonly coordinates: string;

  @ApiProperty({
    example: '2023-11-22T12:00:00Z',
    description: '종료 timestamp',
    required: true,
  })
  @IsDateString()
  readonly endTimestamp: string;

  @ApiProperty({
    example: '여정 제목',
    description: '여정 제목',
    required: true,
  })
  @IsString()
  readonly title: string;

  @IsObject()
  @ApiProperty({
    description: '노래 정보',
    required: true,
  })
  readonly song: object;
}

export class EndJourneyResDTOV2 {
  @ApiProperty({
    example: 20,
    description: '여정 id',
    required: true,
  })
  readonly journeyId: number;

  @ApiProperty({
    example: '37.555946 126.972384,37.555946 126.972384',
    description: '위치 좌표',
    required: true,
  })
  readonly coordinates: string;

  @ApiProperty({
    example: '2023-11-22T15:30:00.000+09:00',
    description: '여정 종료 시간',
    required: true,
  })
  readonly endTimestamp: string;

  @ApiProperty({
    example: 2,
    description: '기록된 coordinate 수',
    required: true,
  })
  readonly numberOfCoordinates: number;

  @ApiProperty({
    description: '노래 정보',
    required: true,
  })
  readonly song: object;
}
