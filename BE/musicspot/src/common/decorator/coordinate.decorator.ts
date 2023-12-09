import {
  registerDecorator,
  ValidationOptions,
  ValidationArguments,
} from 'class-validator';
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
          if (Array.isArray(value)) {
            if (value.length === 2) {
              return true;
            } else {
              for (const arr of value) {
                if (!Array.isArray(arr) || arr.length !== 2) {
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
