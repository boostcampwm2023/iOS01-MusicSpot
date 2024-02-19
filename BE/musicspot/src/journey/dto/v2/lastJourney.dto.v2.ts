import { ApiProperty } from '@nestjs/swagger';
import { JourneyV2DTO } from './jounrey.dto';

export class LastJourneyResV2DTO {
  @ApiProperty({ description: '여정 ID', type: JourneyV2DTO })
  readonly jounrey: JourneyV2DTO;

  @ApiProperty({ description: '여정 마무리 여부' })
  readonly isRecording: boolean;
}
