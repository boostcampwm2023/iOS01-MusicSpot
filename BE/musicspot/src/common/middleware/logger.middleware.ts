import { Injectable, NestMiddleware } from '@nestjs/common';
import { Response, Request, NextFunction } from 'express';
import { winstonLogger } from '../logger/winston.util';

@Injectable()
export class LoggerMiddleware implements NestMiddleware {
  use(req: Request, res: Response, next: NextFunction) {
    try {
      const { ip, method, originalUrl } = req;
      res.on('finish', () => {
        const { statusCode } = res;
        // console.log(res);
        if (statusCode >= 400 && statusCode < 500) {
          winstonLogger.warn(
            `[${method}]${originalUrl}(${statusCode}) ${ip}  Reqbody:${JSON.stringify(
              req.body,
              null,
              2,
            )}`,
          );
        } else if (statusCode >= 500) {
          winstonLogger.error(
            `[${method}]${originalUrl}(${statusCode}) ${ip}  Reqbody:${JSON.stringify(
              req.body,
              null,
              2,
            )}`,
          );
        } else {
          winstonLogger.log(
            `[${method}]${originalUrl}(${statusCode}) ${ip}  Reqbody:${JSON.stringify(
              req.body,
              null,
              2,
            )}`,
          );
        }
      });
    } catch (err) {
      console.log(err);
    }

    next();
  }
}
