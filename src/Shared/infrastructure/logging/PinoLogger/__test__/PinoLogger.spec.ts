import { Controller, Get, RequestMethod, Logger } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import { PINO_LOGGER } from './../Symbols';

import { PinoLoggerModule } from './../PinoLoggerModule';
import { PinoLogger } from './../PinoLogger';
import { TestApp } from './utils/App';

describe('Pino Logger module', function () {
  it('boots successfully', async function () {
    const rootModule = await Test.createTestingModule({
      imports: [PinoLoggerModule.forRoot({})],
    }).compile();

    expect(rootModule.get(PINO_LOGGER)).toBeDefined();
  });

  it('logger is publicly accessible', async () => {
    @Controller('/')
    class TestController {
      constructor(private readonly logger: PinoLogger) {}
      @Get()
      get() {
        expect(this.logger.logger.constructor.name).toEqual('Pino');
      }
    }

    await new TestApp({
      controllers: [TestController],
    })
      .forRoot()
      .run();
  });

  it('logs without config', async () => {
    const message = `${Math.random()}`;

    @Controller('/')
    class TestController {
      private readonly logger = new Logger(TestController.name);
      @Get()
      get() {
        this.logger.log(message);
        return {};
      }
    }

    const logs = await new TestApp({
      controllers: [TestController],
    })
      .forRoot()
      .run();

    expect(logs.some(({ msg }) => msg === message));
  });

  it('logs objects', async () => {
    const message = `${Math.random()}`;

    @Controller('/')
    class TestController {
      private readonly logger = new Logger(TestController.name);
      @Get()
      get() {
        this.logger.log({ someProp: message });
        return {};
      }
    }

    const logs = await new TestApp({
      controllers: [TestController],
    })
      .forRoot()
      .run();

    expect(logs.some(({ someProp }) => someProp !== undefined)).toBeTruthy();
  });

  describe('forRoutes param', () => {
    it('logs depending on route config', async () => {
      @Controller('/')
      class TestController {
        private readonly logger = new Logger(TestController.name);

        @Get('/include')
        include() {
          return {};
        }
        @Get('/exclude')
        exclude() {
          return {};
        }
      }

      const testApp = await new TestApp({
        controllers: [TestController],
      }).forRoot({
        forRoutes: [TestController],
        exclude: [{ method: RequestMethod.GET, path: '/exclude' }],
      });

      let logs = await testApp.run('/include');

      expect(logs.some(({ req }) => req?.url === '/include')).toBeTruthy();

      logs = await testApp.run('/exclude');

      expect(logs.some(({ req }) => req?.url === '/exclude')).toBeFalsy();
    });
  });
});
