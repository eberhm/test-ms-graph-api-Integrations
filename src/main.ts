import { INestApplication, Logger, ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { AppModule } from './app.module';
import { PinoLogger } from './Shared/infrastructure/logging/PinoLogger/PinoLogger';
import { WorkerModule } from './worker.module';

// ENABLE FOR LOCAL DEVELOPMENT
// AWS.config.update({
//   region: process.env.AWS_REGION, // aws region
//   accessKeyId: process.env.ACCESS_KEY_ID, // aws access key id
//   secretAccessKey: process.env.SECRET_ACCESS_KEY, // aws secret access key
// });

async function bootstrap() {
  const app = await getApp();

  const config = app.get(ConfigService);
  const port = config.get('port');

  app.useLogger(app.get(PinoLogger));

  app.useGlobalPipes(
    new ValidationPipe({
      transform: true,
      transformOptions: { enableImplicitConversion: true },
    }),
  );

  const openAPIConfig = new DocumentBuilder()
    .setTitle('Example Onlyfy WebService')
    .setDescription('API description')
    .setVersion('1.0')
    .build();

  const document = SwaggerModule.createDocument(app, openAPIConfig);

  SwaggerModule.setup('doc', app, document);

  await app.listen(port);

  Logger.log(`Listening at http://localhost:${port}`);
}

async function getApp(): Promise<INestApplication> {
  const applicationMode = process.env.APPLICATION_MODE || 'API';
  
  if(applicationMode === 'WORKER') {
    return NestFactory.create(WorkerModule, {
      bufferLogs: true,
    });
  }

  return NestFactory.create(AppModule, {
    bufferLogs: true,
  });
}

bootstrap();
