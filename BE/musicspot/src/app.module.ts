import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { MongooseModule } from '@nestjs/mongoose';
import { JournalsModule } from './journals/journals.module';
import { JournalsController } from './journals/journals.controller';
import { JournalsService } from './journals/journals.service';
import { PersonModule } from './person/person.module';
import { SpotsModule } from './spots/spots.module';
@Module({
  imports: [
    MongooseModule.forRoot('mongodb://192.168.174.128:27017/musicspotDB'),
    JournalsModule,
    PersonModule,
    SpotsModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
