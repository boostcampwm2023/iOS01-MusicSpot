import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { MongooseModule } from '@nestjs/mongoose';
import { JourneyModule } from './journey/journey.module';
import { UserModule } from './user/user.module';
import { SpotModule } from './spot/spot.module';
@Module({
  imports: [
    MongooseModule.forRoot('mongodb://192.168.174.128:27017/musicspotDB'),
    JourneyModule,
    UserModule,
    SpotModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
