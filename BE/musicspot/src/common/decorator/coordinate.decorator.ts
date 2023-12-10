import {
  registerDecorator,
  ValidationOptions,
  ValidationArguments,
} from 'class-validator';
import { is1DArray, is2DArray } from '../util/coordinate.util';

export function IsCoordinate(validationOptions?: ValidationOptions) {
  return function (object: Object, propertyName: string) {
    registerDecorator({
      name: 'isCoordinate',
      target: object.constructor,
      propertyName: propertyName,
      options: validationOptions,
      validator: {
        validate(
          receiveValue: string | number[] | number[][],
          args: ValidationArguments,
        ) {
          const value =
            typeof receiveValue === 'string'
              ? JSON.parse(receiveValue)
              : receiveValue;

          if (!is1DArray(value)) {
            return false;
          }
          return true;
        },
      },
    });
  };
}

export function IsCoordinates(validationOptions?: ValidationOptions) {
  return function (object: Object, propertyName: string) {
    registerDecorator({
      name: 'isCoordinates',
      target: object.constructor,
      propertyName: propertyName,
      options: validationOptions,
      validator: {
        validate(
          receiveValue: string | number[] | number[][],
          args: ValidationArguments,
        ) {
          const value =
            typeof receiveValue === 'string'
              ? JSON.parse(receiveValue)
              : receiveValue;

          if (!is2DArray(value)) {
            return false;
          }
          return true;
        },
      },
    });
  };
}
