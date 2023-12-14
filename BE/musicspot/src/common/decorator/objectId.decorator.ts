import {
  registerDecorator,
  ValidationOptions,
  ValidationArguments,
} from 'class-validator';
import { is1DArray, is2DArray } from '../util/coordinate.util';
import mongoose from 'mongoose';

export function IsObjectId(validationOptions?: ValidationOptions) {
  return function (object: Object, propertyName: string) {
    registerDecorator({
      name: 'isObjectId',
      target: object.constructor,
      propertyName: propertyName,
      options: validationOptions,
      validator: {
        validate(receiveValue: string, args: ValidationArguments) {
          if (!mongoose.Types.ObjectId.isValid(receiveValue)) {
            return false;
          }
          return true;
        },
      },
    });
  };
}
