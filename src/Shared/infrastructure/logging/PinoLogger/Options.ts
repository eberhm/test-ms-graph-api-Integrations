import { MiddlewareConfigProxy } from '@nestjs/common/interfaces';
import { PrettyOptions, LoggerOptions, DestinationStream } from 'pino';
import { Options } from 'pino-http';

export interface PinoLoggerOptions {
  prettyPrint?: PrettyOptions;
  forRoutes?: Parameters<MiddlewareConfigProxy['forRoutes']>;
  exclude?: Parameters<MiddlewareConfigProxy['exclude']>;
  pinoHttpOptions?: Options;
  pinoOptions?: LoggerOptions;
  stream?: DestinationStream;
}
