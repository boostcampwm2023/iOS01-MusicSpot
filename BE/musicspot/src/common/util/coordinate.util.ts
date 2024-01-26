export const is1DArray = (arr) => {
  if (Array.isArray(arr)) {
    if (arr.length !== 2) {
      return false;
    }
    if (!isInCoordinateRange(arr)) {
      return false;
    }
  } else {
    return false;
  }

  return true;
};

export const is2DArray = (arr) => {
  if (Array.isArray(arr)) {
    if (arr.some((item) => !is1DArray(item))) {
      return false;
    }
  }

  return true;
};

export const isInCoordinateRange = (pos) => {
  const [lat, lon] = pos;
  if (typeof lat !== 'number' || typeof lon !== 'number') {
    return false;
  }
  if (!(lat <= 90 && lat >= -90)) {
    return false;
  }
  if (!(lon <= 180 && lon >= -180)) {
    return false;
  }
  return true;
};



export const parseCoordinateFromDtoToGeo = (coordinate: [number, number])=>{
  // coordinate = [1, 2]
  return `${coordinate.join(' ')}`

}

export const parseCoordinateFromGeoToDto = (coordinate: string) =>{
  // coordinate = 'POINT(1 2)'

  const pointLen = 'POINT('.length;
  const numberOfCoordinate = coordinate.slice(pointLen, -1);
  return numberOfCoordinate.split(' ').map(pos=>Number(pos));

}

export const parseCoordinatesFromDtoToGeo = (coordinates: number[][]) =>{
  // coordinates = [[1,2], [3,4]]
  return `${coordinates.map(coordinate=>`${coordinate[0]} ${coordinate[1]}`).join(',')}`
}

export const parseCoordinatesFromGeoToDto = (coordinates: string) :number[][]=>{
  const lineStringLen = 'LINESTRING('.length;
  const numberOfCoordinates = coordinates.slice(lineStringLen, -1);
  return numberOfCoordinates.split(',').map(coordinate=>coordinate.split(' ').map(num=>Number(num.trim())))
}