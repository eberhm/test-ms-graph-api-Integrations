import PinoPretty, { PrettyOptions } from 'pino-pretty';
import { LogDescriptor } from 'pino';

module.exports = (opts: PrettyOptions) =>
  PinoPretty({
    levelFirst: true,
    hideObject: false,
    colorize: true,
    translateTime: 'yyyy-mm-dd HH:MM:ss',
    ignore: 'pid,hostname,context',
    sync: false, // set to true on jest
    singleLine: true,
    messageFormat: (log: LogDescriptor, messageKey) => {
      const message = log[messageKey] as string;

      const { context, req, res } = log;

      let output = message;
      if (req?.id) {
        // HTTP Request, should follow this format
        output = `${req.method} ${res?.statusCode} - ${req.url} - FROM ${req.remoteAddress} - ${message}`;
      } else {
        // Standard log, should follow this format
        output = `${context ? `[${context}]: ` : ''}${
          message ? `${message}` : ''
        } `;
      }
      return output;
    },
    ...opts,
  });
