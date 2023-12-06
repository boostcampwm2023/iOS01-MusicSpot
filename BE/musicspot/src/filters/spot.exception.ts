import { HttpStatus } from '@nestjs/common';
import { BaseException } from './base.exception';
import {
  SpotExceptionCodeEnum,
  SpotExceptionMessageEnum,
} from './exception.enum';

export class SpotNotFoundException extends BaseException {
  constructor() {
    super(SpotExceptionCodeEnum.SpotNotFound, HttpStatus.NOT_FOUND);
    this.message = SpotExceptionMessageEnum.SpotNotFound;
  }
}

export class SpotRecordFail extends BaseException {
  constructor() {
    super(
      SpotExceptionCodeEnum.SpotRecordFail,
      HttpStatus.INTERNAL_SERVER_ERROR,
    );
    this.message = SpotExceptionMessageEnum.SpotRecordFail;
  }
}
