import { CustomRepository } from "src/common/decorator/customRepository.decorator";
import { Repository } from "typeorm";
import { Journey } from "../entities/journey.entity";

@CustomRepository(Journey)
export class JourneyRepository extends Repository<Journey>{};