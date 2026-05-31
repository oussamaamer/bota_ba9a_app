import { NestFactory } from '@nestjs/core';
import { ValidationPipe, Logger } from '@nestjs/common';
import * as dotenv from 'dotenv';
import helmet from 'helmet';
import compression from 'compression';
import { AppModule } from './app.module';
import { HttpExceptionFilter } from './common/filters/http-exception.filter';
import { ResponseInterceptor } from './common/interceptors/response.interceptor';

dotenv.config();

async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    logger: ['log', 'error', 'warn', 'debug', 'verbose'],
  });

  const logger = new Logger('Bootstrap');

  // Security
  app.use(helmet());
  app.use(compression());

  // CORS — allow Flutter app and web clients
  app.enableCors({
    origin: true,
    methods: ['GET', 'POST', 'PATCH', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    credentials: true,
  });

  // Global validation pipe — validates all DTOs
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      transformOptions: {
        enableImplicitConversion: true,
      },
    }),
  );

  // Global exception filter — standard error format
  app.useGlobalFilters(new HttpExceptionFilter());

  // Global response interceptor — standard success format
  app.useGlobalInterceptors(new ResponseInterceptor());

  const port = process.env.PORT || 3001;;
  await app.listen(port);

  logger.log(`🔥 BOTABA9A Backend running on http://localhost:${port}`);
  logger.log(`📡 Environment: ${process.env.NODE_ENV || 'development'}`);
}

bootstrap();
