import { NestFactory } from '@nestjs/core';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { AppModule } from './app.module';
import { ValidationPipe, VersioningType } from '@nestjs/common';
import { NestExpressApplication } from '@nestjs/platform-express';
import { AllExceptionFilter } from './filters/exception.filter';
import * as expressBasicAuth from 'express-basic-auth';
import * as dotenv from 'dotenv';

dotenv.config();
async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);
  app.enableVersioning({
    type: VersioningType.URI,
  });
  app.use(
    //이 부분 추가
    ['/api'], // docs(swagger end point)에 진입시
    expressBasicAuth({
      challenge: true,
      users: {
        [process.env.SWAGGER_USER]: process.env.SWAGGER_PASSWORD, // 지정된 ID/비밀번호
      },
    }),
  );
  const config = new DocumentBuilder()
    .setTitle('Music Spot') // 문서의 제목
    .setDescription('iOS01 Music Spot App API') // 문서의 간단한 설명
    .setVersion('2.0') // API의 버전(업데이트 버전)
    .addTag('Music Spot')
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document, {
    swaggerOptions: {
      persistAuthorization: true,
    },
  });
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
