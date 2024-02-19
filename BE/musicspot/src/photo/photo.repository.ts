import { CustomRepository } from '../common/decorator/customRepository.decorator';
import { Repository } from 'typeorm';
import { Photo } from './entity/photo.entity';

@CustomRepository(Photo)
export class PhotoRepository extends Repository<Photo> {}
