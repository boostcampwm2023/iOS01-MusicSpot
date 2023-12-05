export enum JourneyExceptionCodeEnum {
  JourneyNotFound = '0001',
  UnexpectedError = '9999',
}

export enum JourneyExceptionMessageEnum {
  JourneyNotFound = 'journeyId에 해당하는 Journey가 없습니다.',
  UnexpectedError = '예상치 못한 오류입니다.',
}

export enum SpotExceptionCodeEnum {
  SpotNotFound = '0003',
  UnexpectedError = '9997',
}

export enum SpotExceptionMessageEnum {
  SpotNotFound = 'SpotId에 해당하는 Spot이 없습니다.',
  UnexpectedError = '예상치 못한 오류입니다.',
}

export enum UserExceptionMessageEnum {
  UserAlreadyExist = '이미 존재하는 User Id 입니다.',
  UserNotFound = 'UserId에 해당하는 User가 없습니다.',
}
export enum UserExceptionCodeEnum {
  UserAlreadyExist = '0010',
  UserNotFound = '0011',
}
