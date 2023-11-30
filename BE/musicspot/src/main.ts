import { NestFactory } from '@nestjs/core';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { NestExpressApplication } from '@nestjs/platform-express';
import { AllExceptionFilter } from './filters/exception.filter';
import { winstonLogger } from './common/logger/winston.util';
async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule, {
    logger: winstonLogger,
  });
  const config = new DocumentBuilder()
    .setTitle('Music Spot') // 문서의 제목
    .setDescription('iOS01 Music Spot App API') // 문서의 간단한 설명
    .setVersion('1.0') // API의 버전(업데이트 버전)
    .addTag('Music Spot')
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  app.useGlobalFilters(new AllExceptionFilter());
  await app.listen(3000);
}
bootstrap();
