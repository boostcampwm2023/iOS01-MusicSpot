import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Photo } from '../entity/photo.entity';
import { Repository } from 'typeorm';

@Injectable()
export class PhotoService {
  constructor(
    @InjectRepository(Photo) private photoRepository: Repository<Photo>,
  ) {}

  async deletePhoto(photoId) {
    return await this.photoRepository.delete(photoId);
  }
}
