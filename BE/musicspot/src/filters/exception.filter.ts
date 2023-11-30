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
    const status = err.status;
    if (err instanceof BaseException) {
      err.timestamp = new Date().toISOString();
      err.path = req.url;
      res.status(status).json({
        errorCode: err.errorCode,
        statusCode: status,
        timestamp: err.timestamp,
        path: err.path,
        message: err.message,
      });
    } else {
      res.status(status).json(err);
      // res.send({ ...err, timestamp: new Date().toISOString() });
    }
  }
}
