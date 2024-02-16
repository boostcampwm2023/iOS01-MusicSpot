import { Module } from '@nestjs/common';
import { PhotoController } from '../controller/photo.controller';
import { PhotoService } from '../service/photo.service';
import { TypeOrmExModule } from '../../dynamic.module';
import { PhotoRepository } from '../photo.repository';

@Module({
  imports: [TypeOrmExModule.forFeature([PhotoRepository])],
  controllers: [PhotoController],
  providers: [PhotoService],
})
export class PhotoModule {}
