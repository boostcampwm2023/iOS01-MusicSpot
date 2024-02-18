import { Journey } from '../../journey/entities/journey.entity';
import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  ManyToOne,
  JoinColumn,
  OneToMany,
} from 'typeorm';
import { Photo } from '../../photo/entity/photo.entity';
import {JourneyV2} from "../../journey/entities/journey.v2.entity";

@Entity({ name: 'spot' })
export class SpotV2 {
  @PrimaryGeneratedColumn()
  spotId: number;

  @Column()
  journeyId: number;

  @Column('geometry')
  coordinate: string;

  @Column()
  timestamp: string;

  @Column({
    nullable: true,
  })
  photoKey: string;

  @Column()
  spotSong: string;

  @ManyToOne(() => JourneyV2, (journey) => journey.spots)
  @JoinColumn({ name: 'journeyId' })
  journey: JourneyV2;

  @OneToMany(() => Photo, (photo) => photo.spot)
  photos: Photo[];
}
