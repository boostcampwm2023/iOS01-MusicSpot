import {
  registerDecorator,
  ValidationOptions,
  ValidationArguments,
} from 'class-validator';
import { elementAt } from 'rxjs';

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
          // if (!(Array.isArray(value) && value.length == 2)) {
          //   return false;
          // }
          // if (!value.every((element) => element >= 0)) {
          //   return false;
          // }
          // return true;
          if (Array.isArray(value)) {
            if (value.length === 2 && value.every((element) => element >= 0)) {
              return true;
            } else {
              for (const arr of value) {
                if (
                  !Array.isArray(arr) ||
                  arr.length !== 2 ||
                  arr.some((element) => element < 0)
                ) {
                  return false;
                }
              }
              return true;
            }
          }
        },
      },
    });
  };
}
