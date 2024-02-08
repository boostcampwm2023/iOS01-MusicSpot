export const isPointString = (pointString: string): boolean => {
  const regex = /^\d+.\d+\s\d+.\d+$/;
  if (!pointString.match(regex)) {
    return false;
  }
  if (!isCorrectCoordinateRange(pointString)) {
    return false;
  }
  return true;
};

export const isLinestring = (lineString: string): boolean => {
  const regex: RegExp =
    /^\d+.\d+\s\d+.\d+,(\d+.\d+\s\d+.\d+,)*\d+.\d+\s\d+.\d+$/;
  console.log(':ASD');
  if (!lineString.match(regex)) {
    return false;
  }

  const points = lineString.split(',');
  for (let i = 0; i < points.length; i++) {
    if (!isCorrectCoordinateRange(points[i])) {
      return false;
    }
  }
  return true;
};

export const isCorrectCoordinateRange = (pointString: string): boolean => {
  const [lat, lon] = pointString.split(' ').map((str) => Number(str));
  if (lat > 90 || lat < -90) {
    return false;
  }
  if (lon > 180 || lon < -180) {
    return false;
  }

  return true;
};

export const parseCoordinateFromDtoToGeoV2 = (coordinate: string): string => {
  // coordinate = 1 2
  return `POINT(${coordinate})`;
};

export const parseCoordinateFromGeoToDtoV2 = (coordinate: string): string => {
  // coordinate = 'POINT(1 2)'

  const pointLen = 'POINT('.length;
  return coordinate.slice(pointLen, -1);
};

export const parseCoordinatesFromDtoToGeoV2 = (coordinates: string): string => {
  // coordinates = 1 2,3 4
  return `LINESTRING(${coordinates})`;
};

export const parseCoordinatesFromGeoToDtoV2 = (coordinates: string): string => {
  // coordinates = 'LINESTRING(1 2,3 4)'
  const pointLen = 'LINESTRING'.length;
  return coordinates.slice(pointLen, -1);
};
