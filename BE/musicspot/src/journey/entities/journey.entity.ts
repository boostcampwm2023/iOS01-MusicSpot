import { UUID } from 'crypto';
import { Spot } from '../../spot/entities/spot.entity';
import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  OneToMany,
  JoinColumn,
} from 'typeorm';
@Entity()
export class Journey {
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
  @OneToMany(() => Spot, (spot) => spot.journey)
  spots: Spot[];
}
