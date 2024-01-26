import { Injectable } from '@nestjs/common';
import {Spot} from '../entities/spot.entity'
import {
  SpotNotFoundException,
  SpotRecordFail,
} from 'src/filters/spot.exception';
import {
  S3,
  bucketName,
  makePresignedUrl,
} from '../../common/s3/objectStorage';
import { JourneyNotFoundException, coordinateNotCorrectException } from 'src/filters/journey.exception';
import { is1DArray, parseCoordinateFromDtoToGeo } from 'src/common/util/coordinate.util';
import { SpotRepository } from '../repository/spot.repository';
import { RecordSpotResDTO } from '../dto/recordSpot.dto';
import { JourneyRepository } from 'src/journey/repository/journey.repository';



@Injectable()
export class SpotService {
  constructor(
    private spotRepository: SpotRepository, private journeyRepository: JourneyRepository) {}
  

    async uploadPhotoToStorage(journeyId, file) {
      try{
        const key = `${journeyId}/${Date.now()}`;
        const result = await S3.putObject({
          Bucket: bucketName,
          Key: key,
          Body: file.buffer,
        }).promise();
    
        return key;
      } catch(err){
        throw new SpotRecordFail();
      }
    }
    
    async insertToSpot(spotData){
      const point = `POINT(${parseCoordinateFromDtoToGeo(spotData.coordinate)})`;
      const data = {...spotData, journeyId :Number(spotData.journeyId), coordinate: point }
      
      return await this.spotRepository.save(data);
    }
    
    async updateCoordinatesToJourney(journeyId, coordinate){
      const parsedCoordinate = parseCoordinateFromDtoToGeo(coordinate);
      const originalJourney = await this.journeyRepository.findOne({where:{journeyId}})
      const lineStringLen = 'LINESTRING('.length;
    
      if(!originalJourney){
        throw new JourneyNotFoundException();
      }
      originalJourney.coordinates = `LINESTRING(${originalJourney.coordinates.slice(lineStringLen, -1)}, ${parsedCoordinate})`
      
      
      return await this.journeyRepository.save(originalJourney);
    }
    
    async create(file, recordSpotDto){
      let parsedCoordinate;
      try {
        parsedCoordinate = JSON.parse(recordSpotDto.coordinate);
      } catch (err) {
        throw new coordinateNotCorrectException();
      }
      if (!is1DArray(parsedCoordinate)) {
        throw new coordinateNotCorrectException();
      }
    
      const photoKey = await this.uploadPhotoToStorage(
        recordSpotDto.journeyId,
        file,
      );
      const presignedUrl = makePresignedUrl(photoKey);
    
      const createdSpotData = await this.insertToSpot({
        ...recordSpotDto,
        photoKey,
        coordinate: parsedCoordinate
      });
      const updatedJourneyData = await this.updateCoordinatesToJourney(recordSpotDto.journeyId, parsedCoordinate)
    
      const returnData:RecordSpotResDTO  = {
        journeyId : createdSpotData.journeyId,
        coordinate : parsedCoordinate,
        timestamp : createdSpotData.timestamp,
        photoUrl : presignedUrl
    
      }
    
      return returnData
    }
    
    async getSpotImage(spotId: number) {
      const spot = await this.spotRepository.findOne({where: {spotId}});
      if (!spot) {
        throw new SpotNotFoundException();
      }
    
      return spot.photoKey;
    }
}


