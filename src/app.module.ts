import { Module } from '@nestjs/common';
import { HttpRequesterModule } from './Shared/infrastructure/http/HttpRequesterModule';
import { PinoLoggerModule } from './Shared/infrastructure/logging/PinoLogger/PinoLoggerModule';
import { SystemModule } from './Shared/system.module';
import { ConfigModule } from '@nestjs/config';
import { configuration } from './config/configuration';
import { validationSchema } from './config/validation';
import { AuthenticationModule } from './Authentication/authentication.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [configuration],
      validationSchema,
    }),
    PinoLoggerModule.forRoot(),
    SystemModule,
    HttpRequesterModule,
    AuthenticationModule
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
