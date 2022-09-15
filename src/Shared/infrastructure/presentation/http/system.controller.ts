import { Controller, Get } from '@nestjs/common';

@Controller('/_system')
export class SystemController {
  @Get('alive')
  async getHealthcheck() {
    return {};
  }
}
