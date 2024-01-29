import { ApiProperty } from "@nestjs/swagger";
import { UUID } from "crypto";
import { Entity, Column, PrimaryGeneratedColumn } from "typeorm";

@Entity()
export class User{
    @ApiProperty({example: "0f8fad5b-d9cb-469f-a165-70867728950e"})
    @PrimaryGeneratedColumn()
    userId: UUID;

}