import { ApiProperty } from '@nestjs/swagger';
import { IsCoordinate } from '../../common/decorator/coordinate.decorator';
export class RecordJourneyResponseDTO {
  @ApiProperty({
    example: [37.555946, 126.972384],
    description: '저장된 위치 좌표',
    required: true,
  })
  @IsCoordinate({
    message: '배열의 각 요소는 양수여야 하고 두 개의 요소만 허용됩니다.',
  })
  readonly coordinate: number[] | number[][];
}
