import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { MongooseModule } from '@nestjs/mongoose';
import { JournalsModule } from './journals/journals.module';
import { JournalsController } from './journals/journals.controller';
import { JournalsService } from './journals/journals.service';
import { PersonModule } from './person/person.module';
<<<<<<< HEAD
import { SpotsModule } from './spots/spots.module';
=======
>>>>>>> c5b093fbb6f6c5727fbacc7ef1b2583701b491cf
@Module({
  imports: [
    MongooseModule.forRoot('mongodb://192.168.174.128:27017/musicspotDB'),
    JournalsModule,
    PersonModule,
<<<<<<< HEAD
    SpotsModule,
=======
>>>>>>> c5b093fbb6f6c5727fbacc7ef1b2583701b491cf
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
