import { Journey } from '../../journey/entities/journey.entity';
import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';

@Entity()
export class Spot {
  @PrimaryGeneratedColumn()
  spotId: number;

  @Column()
  journeyId: number;

  @Column('geometry')
  coordinate: string;

  @Column()
  timestamp: string;

  @Column()
  photoKey: string;

  @ManyToOne(() => Journey, (journey) => journey.spots)
  @JoinColumn({ name: 'journeyId' })
  journey: Journey;
}
