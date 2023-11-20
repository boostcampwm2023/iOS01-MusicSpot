import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { MongooseModule } from '@nestjs/mongoose';
import { JournalsModule } from './journals/journals.module';
import { JournalsController } from './journals/journals.controller';
import { JournalsService } from './journals/journals.service';
import { PersonModule } from './person/person.module';
@Module({
  imports: [
    MongooseModule.forRoot('mongodb://192.168.174.128:27017/musicspotDB'),
    JournalsModule,
    PersonModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
