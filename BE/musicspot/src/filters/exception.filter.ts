import { ArgumentsHost, Catch, ExceptionFilter } from '@nestjs/common';
import { BaseException } from './base.exception';
import { UnexpectedException } from './unexpected.exception';

@Catch()
export class AllExceptionFilter implements ExceptionFilter {
  catch(exception: any, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const req = ctx.getRequest();
    const res = ctx.getResponse();
    const err = exception;

    if (err instanceof BaseException) {
      err.timestamp = new Date().toISOString();
      err.path = req.url;
      res.status(err.statusCode).json({
        errorCode: err.errorCode,
        statusCode: err.statusCode,
        timestamp: err.timestamp,
        path: err.path,
        message: err.message,
      });
    } else {
      res.status(err.status).json({
        statusCode: err.status,
        timestamp: new Date().toISOString(),
        path: req.url,
        message: err.response.message,
      });
    }
  }
}
