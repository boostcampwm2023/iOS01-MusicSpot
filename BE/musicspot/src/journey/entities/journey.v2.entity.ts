import { UUID } from 'crypto';
import { SpotV2 } from '../../spot/entities/spot.v2.entity';
import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  OneToMany,
  JoinColumn,
} from 'typeorm';
@Entity({ name: 'journey'})
export class JourneyV2 {
  @PrimaryGeneratedColumn()
  journeyId: number;

  @Column({ length: 36 })
  userId: UUID;

  @Column({ length: 30 })
  title: string;

  @Column()
  startTimestamp: string;

  @Column()
  endTimestamp: string;

  @Column()
  song: string;

  @Column('geometry')
  coordinates: string;

  // @OneToMany(()=> Spot, spot => spot.journeyId)
  @OneToMany(() => SpotV2, (spot) => spot.journey)
  spots: SpotV2[];
}
