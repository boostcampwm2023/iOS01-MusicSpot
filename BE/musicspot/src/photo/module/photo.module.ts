import { Module } from '@nestjs/common';
import { PhotoController } from '../controller/photo.controller';
import { PhotoService } from '../service/photo.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Photo } from '../entity/photo.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Photo])],
  controllers: [PhotoController],
  providers: [PhotoService],
})
export class PhotoModule {}
