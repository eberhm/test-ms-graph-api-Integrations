import { OnModuleInit } from '@nestjs/common';

import { PrismaService } from './prisma.service';

export type Methods = string[];

export abstract class PrismaRepository implements OnModuleInit {
  constructor(protected readonly repository: PrismaService) {}

  onModuleInit() {
    this.repository.$use(async (params, next) => {
      // TODO: wrap profiler?
      const before = Date.now();

      const result = await next(params);

      const after = Date.now();

      console.log(
        `Query ${params.model}.${params.action} took ${after - before}ms`,
      );

      return result;
    });
  }
}
