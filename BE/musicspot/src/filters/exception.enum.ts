export enum JourneyExceptionCodeEnum {
  JourneyNotFound = '0001',
  CoordinateNotCorrect = '0002',
  UnexpectedError = '9999',
}

export enum JourneyExceptionMessageEnum {
  JourneyNotFound = 'journeyId에 해당하는 Journey가 없습니다.',
  CoordinateNotCorrect = 'Coordinate는 각각의 원소는 범위를 만족하는 숫자 두개로 이루어져있습니다.(-90~90, -180~180)',
  UnexpectedError = '예상치 못한 오류입니다.',
}

export enum SpotExceptionCodeEnum {
  SpotNotFound = '0020',
  SpotRecordFail = '0021',
}

export enum SpotExceptionMessageEnum {
  SpotNotFound = 'SpotId에 해당하는 Spot이 없습니다.',
  SpotRecordFail = 'Spot 이미지 저장 중 에러가 발생했습니다.',
}

export enum UserExceptionMessageEnum {
  UserAlreadyExist = '이미 존재하는 User Id 입니다.',
  UserNotFound = 'UserId에 해당하는 User가 없습니다.',
}
export enum UserExceptionCodeEnum {
  UserAlreadyExist = '0010',
  UserNotFound = '0011',
}
