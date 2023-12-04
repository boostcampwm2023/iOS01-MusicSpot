import { ArgumentsHost, Catch, ExceptionFilter } from '@nestjs/common';
import { BaseException } from './base.exception';

@Catch()
export class AllExceptionFilter implements ExceptionFilter {
  catch(exception: any, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const req = ctx.getRequest();
    const res = ctx.getResponse();
    const err = exception;
    const { status, response } = err;
    let json = {
      method: req.method,
      path: req.url,
      timestamp: new Date().toISOString(),
    };
    if (err instanceof BaseException) {
      json['errorCode'] = err.errorCode;
      json['message'] = err.message;
      json['statusCode'] = status;
    } else {
      Object.assign(json, response);
    }
    res.status(status).json(json);
  }
}
