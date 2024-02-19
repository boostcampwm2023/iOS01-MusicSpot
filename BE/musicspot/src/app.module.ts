import { MiddlewareConsumer, Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { MongooseModule } from '@nestjs/mongoose';
import { JourneyModule } from './journey/module/journey.module';
import { SpotModule } from './spot/module/spot.module';
import { UserModule } from './user/module/user.module';

import { ReleaseController } from './releasePage/release.controller';
import { LoggerMiddleware } from './common/middleware/logger.middleware';
import { TypeOrmModule } from '@nestjs/typeorm';

import * as dotenv from 'dotenv';
import { User } from './user/entities/user.entity';
import { Journey } from './journey/entities/journey.entity';
import { Spot } from './spot/entities/spot.entity';
import { PhotoModule } from './photo/module/photo.module';
import { Photo } from './photo/entity/photo.entity';
import { DataSource } from 'typeorm';
import { SpotV2 } from './spot/entities/spot.v2.entity';
import { JourneyV2 } from './journey/entities/journey.v2.entity';
dotenv.config();

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'mysql',
      host: process.env.DB_HOST,
      port: Number(process.env.DB_PORT),
      username: process.env.DB_USERNAME,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      entities: [User, Journey, Spot, Photo, SpotV2, JourneyV2],
      synchronize: false,
      legacySpatialSupport: false,
    }),
    // MongooseModule.forRoot(
    //   `mongodb://${process.env.DB_HOST}:${process.env.DB_PORT}/${process.env.DB_NAME}`,
    // ),

    JourneyModule,
    UserModule,
    SpotModule,
    PhotoModule,
  ],
  controllers: [AppController, ReleaseController],
  providers: [AppService],
})
export class AppModule {
  constructor(private dataSource: DataSource) {}
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(LoggerMiddleware).forRoutes('/*');
  }
}
