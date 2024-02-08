import {
  registerDecorator,
  ValidationOptions,
  ValidationArguments,
} from 'class-validator';
import { isLinestring, isPointString } from '../util/coordinate.v2.util';

export function IsCoordinateV2(validationOptions?: ValidationOptions) {
  return function (object: object, propertyName: string) {
    registerDecorator({
      name: 'isCoordinateV2',
      target: object.constructor,
      propertyName: propertyName,
      options: validationOptions,
      validator: {
        validate(receiveValue: string, args: ValidationArguments) {
          return isPointString(receiveValue);
        },
      },
    });
  };
}

export function IsCoordinatesV2(validationOptions?: ValidationOptions) {
  return function (object: object, propertyName: string) {
    registerDecorator({
      name: 'isCoordinatesV2',
      target: object.constructor,
      propertyName: propertyName,
      options: validationOptions,
      validator: {
        validate(receiveValue: string, args: ValidationArguments) {
          return isLinestring(receiveValue);
        },
      },
    });
  };
}
