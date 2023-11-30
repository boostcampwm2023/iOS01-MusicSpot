import { HttpStatus } from '@nestjs/common';
import { BaseException } from './base.exception';
import { JourneyExceptionCodeEnum } from './exception.enum';

export class JourneyNotFoundException extends BaseException {
  constructor() {
    super(JourneyExceptionCodeEnum.JourneyNotFound, HttpStatus.NOT_FOUND);
  }
}
