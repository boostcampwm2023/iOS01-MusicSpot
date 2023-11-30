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
        validate(receivedValue: string | number[], args: ValidationArguments) {
          const value =
            typeof receivedValue === 'string'
              ? JSON.parse(receivedValue)
              : receivedValue;
          if (!(Array.isArray(value) && value.length == 2)) {
            return false;
          }
          if (!value.every((element) => element >= 0)) {
            return false;
          }
          return true;
        },
      },
    });
  };
}
