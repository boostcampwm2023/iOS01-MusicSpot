import { Injectable } from "@nestjs/common";
import { JourneyRepository } from "../repository/journey.repository";
import { StartJourneyReqDTO, StartJourneyResDTO } from '../dto/journeyStart/journeyStart.dto';
import {
  JourneyNotFoundException,
  coordinateNotCorrectException,
} from '../../filters/journey.exception';
import { EndJourneyReqDTO, EndJourneyResDTO } from '../dto/journeyEnd/journeyEnd.dto';
import { RecordJourneyReqDTO, RecordJourneyResDTO } from '../dto/journeyRecord/journeyRecord.dto';
import { is1DArray, parseCoordinateFromGeoToDto, parseCoordinatesFromGeoToDto } from 'src/common/util/coordinate.util';
import { DeleteJourneyReqDTO } from '../dto/journeyDelete.dto';
import { UserRepository } from 'src/user/repository/user.repository';

import { Journey } from '../entities/journey.entity';
import { makePresignedUrl } from "src/common/s3/objectStorage";
import { parse } from "path";

@Injectable()
export class JourneyService{
    constructor(private journeyRepository: JourneyRepository, private userRepository: UserRepository){}

    async insertJourneyData(startJourneyDTO:StartJourneyReqDTO){
      const startPoint = startJourneyDTO.coordinate.join(' ');

      const lineStringOfCoordinates = `LINESTRING(${startPoint}, ${startPoint})`

      const returnedData = await this.journeyRepository.save({...startJourneyDTO, coordinates: lineStringOfCoordinates})

      const [parsedCoordinate] = parseCoordinatesFromGeoToDto(returnedData.coordinates)
      
      const returnData:StartJourneyResDTO = {
        journeyId : returnedData.journeyId,
        coordinate : parsedCoordinate,
        startTimestamp : returnedData.startTimestamp,
      }

      return returnData;
    }

    async end(endJourneyDTO: EndJourneyReqDTO){
      const {coordinates, journeyId, song, title, endTimestamp} = endJourneyDTO;
      const coordinatesLen = coordinates.length;
      const originData = await this.journeyRepository.findOne({where:{journeyId}})
      if(!originData){
        throw new JourneyNotFoundException();
      }

      const originCoordinates =originData.coordinates;
      const newCoordinates = originData.coordinates = originCoordinates.slice(0, -1) + ',' +endJourneyDTO.coordinates.map((item)=> `${item[0]} ${item[1]}`).join(',') + ')'
      const newJourneyData = {...originData, ...endJourneyDTO, song : JSON.stringify(song), coordinates: newCoordinates};
      
      const returnedDate = await this.journeyRepository.save(newJourneyData);

      const parsedCoordinates = parseCoordinatesFromGeoToDto(returnedDate.coordinates)
      const returnData:EndJourneyResDTO = {
        journeyId : returnedDate.journeyId,
        coordinates : parsedCoordinates.slice(parsedCoordinates.length-coordinatesLen),
        endTimestamp : returnedDate.endTimestamp,
        numberOfCoordinates : parsedCoordinates.length,
        song : JSON.parse(returnedDate.song)
      }

      return returnData
    }


    async pushCoordianteToJourney(recordJourneyDTO: RecordJourneyReqDTO) {
      
        const {journeyId, coordinates} = recordJourneyDTO;
        const coordinateLen = coordinates.length;
        const originData = await this.journeyRepository.findOne({where:{journeyId}});
        if(!originData){
          throw new JourneyNotFoundException();
        }
        const originCoordinates =originData.coordinates;

        
        originData.coordinates = originCoordinates.slice(0, -1) + ',' +recordJourneyDTO.coordinates.map((item)=> `${item[0]} ${item[1]}`).join(',') + ')'
        const returnedData =  await this.journeyRepository.save(originData)

        const updatedCoordinate = parseCoordinatesFromGeoToDto(returnedData.coordinates);
        const len = updatedCoordinate.length;

  
        return {coordinates:updatedCoordinate.slice(len-coordinateLen)}
        
    }


    async getJourneyByCoordinationRange(checkJourneyDTO) {
      let { userId, minCoordinate, maxCoordinate } = checkJourneyDTO;
      if (!(Array.isArray(minCoordinate) && Array.isArray(maxCoordinate))) {
        throw new coordinateNotCorrectException();
      }

      minCoordinate = minCoordinate.map((item) => Number(item));
      maxCoordinate = maxCoordinate.map((item) => Number(item));

      if (!(is1DArray(minCoordinate) && is1DArray(maxCoordinate))) {
        throw new coordinateNotCorrectException();
      }
      const coordinatesRange = {
        xMinCoordinate : minCoordinate[0],
        yMinCoordinate : minCoordinate[1],
        xMaxCoordinate : maxCoordinate[0],
        yMaxCoordinate : maxCoordinate[1]
      }
      const returnedData = await this.journeyRepository.manager
          .createQueryBuilder(Journey, "journey")
          .leftJoinAndSelect("journey.spots", "spot")
          .where(`st_within(coordinates, ST_PolygonFromText('POLYGON((:xMinCoordinate :yMinCoordinate, :xMaxCoordinate :yMinCoordinate, :xMaxCoordinate :yMaxCoordinate, :xMinCoordinate :yMaxCoordinate, :xMinCoordinate :yMinCoordinate))'))`, coordinatesRange)
          .where('userId = :userId', {userId})
          .getMany();
      
      return returnedData.map(data =>{
        return this.parseJourneyFromEntityToDto(data)
      })
    }

    async getLastJourneyByUserId(userId){
      const journeys = await this.journeyRepository.manager
      .createQueryBuilder(Journey, "journey")
      .where({userId})
      .leftJoinAndSelect("journey.spots", "spot")
      .getMany()

      if(!journeys){
        return {
          journey : null,
          isRecording: false
        };
      }

      const journeyLen = journeys.length;
      const lastJourneyData = journeys[journeyLen-1];

      if(lastJourneyData.title){
        return {journey:null, isRecording : false}
      }

      
      return {
        journey : this.parseJourneyFromEntityToDto(lastJourneyData),
        isRecording : true
        
    
      }
    
      
    }
    
      async getJourneyById(journeyId) {
        const returnedData =  await this.journeyRepository.manager
          .createQueryBuilder(Journey, "journey")
          .where({journeyId})
          .leftJoinAndSelect("journey.spots", "spot")
          .getOne()
          return this.parseJourneyFromEntityToDto(returnedData);
  
          
      }

      parseJourneyFromEntityToDto(journey){
        const {journeyId, coordinates, startTimestamp, endTimestamp, song, title, spots} = journey;
        return {
          journeyId,
          coordinates : parseCoordinatesFromGeoToDto(coordinates),
          title,
          journeyMetadata : {startTimestamp : journey.startTimestamp, endTimestamp : journey.endTimestamp},
          song : JSON.parse(song),
          spots : journey.spots.map(spot =>{
            return {
              ...spot,
              coordinate : parseCoordinateFromGeoToDto(spot.coordinate),
              photoUrl : makePresignedUrl(spot.photoKey)
            }
          })

        }
      }

      async deleteJourneyById(deletedJourneyDto: DeleteJourneyReqDTO){
        const {journeyId} = deletedJourneyDto;
        return await this.journeyRepository.delete({journeyId})
      }

}

    

