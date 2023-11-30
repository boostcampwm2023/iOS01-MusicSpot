// import { Injectable, NestMiddleware } from '@nestjs/common';
// import { Response, Request, NextFunction } from 'express';
// import { winstonLogger } from '../logger/winston.util';

// @Injectable()
// export class LoggerMiddleware implements NestMiddleware {
//   constructor() {}

//   use(req: Request, res: Response, next: NextFunction) {
//     const { ip, method, originalUrl } = req;

//     res.on('finish', () => {
//       const { statusCode } = res;
//       console.log(statusCode);
//       // if (statusCode >= 400 && statusCode < 500) {
//       //   winstonLogger.warn(`[${method}]${originalUrl}(${statusCode}) ${ip}`);
//       //   console.log('ASDS');
//       // } else if (statusCode >= 500) {
//       //   winstonLogger.error(`[${method}]${originalUrl}(${statusCode}) ${ip}`);
//       // }
//       winstonLogger.warn(`[${method}]${originalUrl}(${statusCode}) ${ip}`);
//     });

//     next();
//   }
// }
