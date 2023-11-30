import { BaseException } from './base.exception';
import { JourneyExceptionCodeEnum } from './exception.enum';
import { HttpStatus } from '@nestjs/common';

export class UnexpectedException extends BaseException {
  constructor() {
    super(
      JourneyExceptionCodeEnum.UnexpectedError,
      HttpStatus.INTERNAL_SERVER_ERROR,
    );
  }
}
