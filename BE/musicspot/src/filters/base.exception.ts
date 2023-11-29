import { HttpException } from '@nestjs/common';
import { IBaseException } from './base.exception.interface';

export class BaseException extends HttpException implements IBaseException {
  constructor(errorCode: string, statusCode: number) {
    super(errorCode, statusCode);
    this.errorCode = errorCode;
    this.statusCode = statusCode;
  }

  errorCode: string;
  statusCode: number;
  timestamp: string;
  path: string;
  message: string;
}
