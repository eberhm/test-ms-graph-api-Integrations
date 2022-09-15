import { join } from 'path';
import { Inject, Injectable, LoggerService } from '@nestjs/common';
import pino, { Logger, Level } from 'pino';
import { PinoLoggerOptions } from './Options';
import { PINO_OPTIONS } from './Symbols';

import { storage } from './storage';
@Injectable()
export class PinoLogger implements LoggerService {
  protected rootLogger: Logger;

  constructor(
    @Inject(PINO_OPTIONS) private readonly options?: PinoLoggerOptions,
  ) {
    const { stream, pinoOptions } = options;

    this.rootLogger = pino(
      {
        ...pinoOptions,
        transport: process.env.NODE_ENV === 'development' && {
          targets:
            process.env.NODE_ENV === 'development'
              ? [
                  {
                    target: join(__dirname, './transports/PinoPrettyTransport'),
                    level: 'trace',
                    options: {
                      ...options.prettyPrint,
                    },
                  },
                ]
              : [],
        },
      },
      stream,
    );
  }

  verbose(message: any, ...optionalParams: any[]) {
    this.call('trace', message, ...optionalParams);
  }

  debug(message: any, ...optionalParams: any[]) {
    this.call('debug', message, ...optionalParams);
  }

  log(message: any, ...optionalParams: any[]) {
    this.call('info', message, ...optionalParams);
  }

  warn(message: any, ...optionalParams: any[]) {
    this.call('warn', message, ...optionalParams);
  }

  error(message: any, ...optionalParams: any[]) {
    this.call('error', message, ...optionalParams);
  }

  public get logger(): pino.Logger {
    return storage.getStore()?.logger || this.rootLogger;
  }

  private call(level: Level, message: any, ...optionalParams: any[]) {
    const objArg: Record<string, any> = {};

    // optionalParams contains extra params passed to logger
    // context name is the last item

    let params: any[] = [];
    if (optionalParams.length !== 0) {
      objArg.context = optionalParams[optionalParams.length - 1];
      params = optionalParams.slice(0, -1);
    }

    if (typeof message === 'object') {
      if (message instanceof Error) {
        objArg.err = message;
      } else {
        Object.assign(objArg, message);
      }
      this.logger[level](objArg, ...params);
    } else {
      this.logger[level](objArg, message, ...params);
    }
  }
}
