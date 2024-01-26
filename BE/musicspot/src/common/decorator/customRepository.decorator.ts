import { SetMetadata } from "@nestjs/common";

export const TYPEORM_EX_CUSTOM_REPOSITORY = "TYPEORM_EX_CUSTOM_REPOSITORY";

export function CustomRepository(entity : Function): ClassDecorator{
    return SetMetadata(TYPEORM_EX_CUSTOM_REPOSITORY, entity);
}

// SetMetadata는 key, value 형태의 값을 취함
// 즉 TYPEORM_EX_CUSTOM_REPOSITORY : entity