import { CustomRepository } from '../../common/decorator/customRepository.decorator';
import { Repository } from 'typeorm';
import { Spot } from '../entities/spot.entity';

@CustomRepository(Spot)
export class SpotRepository extends Repository<Spot> {}
