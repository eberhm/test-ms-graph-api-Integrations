import { Module } from '@nestjs/common';
import { SystemController } from './infrastructure/presentation/http/system.controller';

@Module({
  controllers: [SystemController],
})
export class SystemModule {}
