import { SpotV2 } from '../../spot/entities/spot.v2.entity';
import {
  Entity,
  PrimaryGeneratedColumn,
  ManyToOne,
  JoinColumn,
  Column,
} from 'typeorm';
@Entity()
export class Photo {
  @PrimaryGeneratedColumn()
  photoId: number;

  @Column()
  spotId: number;

  @Column()
  photoKey: string;

  @ManyToOne(() => SpotV2, (spot) => spot.photos, {onDelete: 'CASCADE'})
  @JoinColumn({ name: 'spotId' })
  spot: SpotV2;
}
