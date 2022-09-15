import { join } from 'path';
import {
  Global,
  Module,
  DynamicModule,
  MiddlewareConsumer,
  RequestMethod,
  Inject,
} from '@nestjs/common';
import { Provider } from '@nestjs/common/interfaces';
import pinoHttp from 'pino-http';
import * as express from 'express';

import { Store, storage } from './storage';

import { PinoLogger } from './PinoLogger';
import { PinoLoggerOptions } from './Options';
import { PrettyOptions } from 'pino-pretty';
import { PINO_OPTIONS, PINO_LOGGER } from './Symbols';

const DEFAULT_ROUTES = [{ path: '*', method: RequestMethod.ALL }];

const DEFAULT_OPTIONS = {
  forRoutes: DEFAULT_ROUTES,
};

@Global()
@Module({ providers: [PinoLogger], exports: [PinoLogger] })
export class PinoLoggerModule {
  static forRoot(options?: PinoLoggerOptions): DynamicModule {
    const paramsProvider: Provider<PinoLoggerOptions> = {
      provide: PINO_OPTIONS,
      useValue: { ...DEFAULT_OPTIONS, ...options } || DEFAULT_OPTIONS,
    };

    const pinoProvider = {
      provide: PINO_LOGGER,
      useClass: PinoLogger,
    };

    return {
      module: PinoLoggerModule,
      providers: [pinoProvider, paramsProvider],
      exports: [pinoProvider, paramsProvider],
    };
  }

  constructor(
    @Inject(PINO_OPTIONS) private readonly options?: PinoLoggerOptions,
  ) {}

  configure(consumer: MiddlewareConsumer) {
    const {
      prettyPrint = {},
      forRoutes,
      pinoHttpOptions = {},
      stream,
      exclude = [],
    } = this.options;

    const options = {
      quietReqLogger: true, // turn off adding request context to custom logs (calling manually logger inside a class)
      ...pinoHttpOptions,
      transport: process.env.NODE_ENV === 'development' && {
        targets:
          process.env.NODE_ENV === 'development'
            ? [
                {
                  target: join(__dirname, './transports/PinoPrettyTransport'),
                  level: 'trace',
                  options: {
                    ...prettyPrint,
                  } as PrettyOptions,
                },
              ]
            : [],
      },
    };

    const middleware = pinoHttp(options, stream);

    // @ts-expect-error: root is readonly field, but it's set here
    PinoLogger.logger = middleware.logger;

    consumer
      .apply(middleware, bindLoggerMiddleware)
      .exclude(...exclude, '_system/(.*)')
      .forRoutes(...forRoutes);
  }
}

function bindLoggerMiddleware(
  req: express.Request,
  _res: express.Response,
  next: express.NextFunction,
) {
  // @ts-expect-error: wrong type on arguments
  storage.run(new Store(req.log), next);
}
