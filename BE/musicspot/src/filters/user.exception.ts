import { HttpStatus } from '@nestjs/common';
import { BaseException } from './base.exception';
import {
  UserExceptionCodeEnum,
  UserExceptionMessageEnum,
} from './exception.enum';

export class UserNotFoundException extends BaseException {
  constructor() {
    super(UserExceptionCodeEnum.UserNotFound, HttpStatus.NOT_FOUND);
    this.message = UserExceptionMessageEnum.UserNotFound;
  }
}

export class UserAlreadyExistException extends BaseException {
  constructor() {
    super(UserExceptionCodeEnum.UserAlreadyExist, HttpStatus.CONFLICT);
    this.message = UserExceptionMessageEnum.UserAlreadyExist;
  }
}
