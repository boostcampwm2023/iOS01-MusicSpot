import { ApiProperty } from '@nestjs/swagger';
import { IsDateString, IsUUID } from 'class-validator';
import { UUID } from 'crypto';

export class StartJourneyRequestDTOV2 {
    @ApiProperty({
        example: '2023-11-22T12:00:00Z',
        description: '시작 timestamp',
        required: true,
    })
    @IsDateString()
    readonly startTimestamp: string;
}

export class StartJourneyResponseDTOV2 {
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
