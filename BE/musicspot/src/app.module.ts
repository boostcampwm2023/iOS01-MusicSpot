import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { MongooseModule } from '@nestjs/mongoose';
import { JourneyModule } from './journey/module/journey.module';
import { SpotModule } from './spot/module/spot.module';
import { UserModule } from './user/module/user.module';


import { ReleaseController } from './releasePage/release.controller';

@Module({
  imports: [
    MongooseModule.forRoot(
      `mongodb://${process.env.DB_HOST}:${process.env.DB_PORT}/${process.env.DB_NAME}`,
    ),
    JourneyModule,
    UserModule,
    SpotModule,
  ],
  controllers: [AppController, ReleaseController],
  providers: [AppService],
})
export class AppModule {}
