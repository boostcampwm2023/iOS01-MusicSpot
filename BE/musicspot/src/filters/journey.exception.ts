import { HttpStatus } from '@nestjs/common';
import { BaseException } from './base.exception';
import {
  JourneyExceptionCodeEnum,
  JourneyExceptionMessageEnum,
} from './exception.enum';

export class JourneyNotFoundException extends BaseException {
  constructor() {
    super(JourneyExceptionCodeEnum.JourneyNotFound, HttpStatus.NOT_FOUND);
    this.message = JourneyExceptionMessageEnum.JourneyNotFound;
  }
}

export class coordinateNotCorrectException extends BaseException {
  constructor() {
    super(
      JourneyExceptionCodeEnum.CoordinateNotCorrect,
      HttpStatus.BAD_REQUEST,
    );
    this.message = JourneyExceptionMessageEnum.CoordinateNotCorrect;
  }
}
