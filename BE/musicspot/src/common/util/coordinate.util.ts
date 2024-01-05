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