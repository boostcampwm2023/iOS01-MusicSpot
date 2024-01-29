import { CustomRepository } from "src/common/decorator/customRepository.decorator";
import { User } from "../entities/user.entity";
import { Repository } from "typeorm";
import { CreateUserDTO } from "../dto/createUser.dto";

@CustomRepository(User)
export class UserRepository extends Repository<User>{
};