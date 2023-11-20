import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { MongooseModule } from '@nestjs/mongoose';
import { JourneyModule } from './journey/journey.module';
import { UserModule } from './user/user.module';
import { SpotsModule } from './spots/spots.module';
@Module({
  imports: [
    MongooseModule.forRoot('mongodb://192.168.174.128:27017/musicspotDB'),
    JourneyModule,
    UserModule,
    SpotsModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
