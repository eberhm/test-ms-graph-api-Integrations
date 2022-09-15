import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { configuration } from './config/configuration';
import { PinoLoggerModule } from './Shared/infrastructure/logging/PinoLogger/PinoLoggerModule';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [configuration],
    }),
    PinoLoggerModule.forRoot(),
  ],
  controllers: [],
  providers: [],
})
export class WorkerModule {}
