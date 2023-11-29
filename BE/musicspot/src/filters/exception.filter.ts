import { ArgumentsHost, Catch, ExceptionFilter } from '@nestjs/common';
import { BaseException } from './base.exception';
import { UnexpectedException } from './unexpected.exception';

@Catch()
export class AllExceptionFilter implements ExceptionFilter {
  catch(exception: any, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const req = ctx.getRequest();
    const res = ctx.getResponse();

    const err =
      exception instanceof BaseException
        ? exception
        : new UnexpectedException();

    err.timestamp = new Date().toISOString();
    err.path = req.url;

    res.status(err.statusCode).json({
      errorCode: err.errorCode,
      statusCode: err.statusCode,
      timestamp: err.timestamp,
      path: err.path,
      message: err.message,
    });
  }
}
