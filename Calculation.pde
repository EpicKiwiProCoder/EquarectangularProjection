PVector matmul(PVector inp, float[][] mat) {
  PVector out = new PVector(0,0,0);
  out.x = inp.x*mat[0][0] + inp.y*mat[0][1] + inp.z*mat[0][2];
  out.y = inp.x*mat[1][0] + inp.y*mat[1][1] + inp.z*mat[1][2];
  if (mat.length == 3) {
    out.z = inp.x*mat[2][0] + inp.y*mat[2][1] + inp.z*mat[2][2];
  }
  return out;
}
PVector rx(PVector original, float angle) {
  float[][] rotationX = {
  {1,0,0},
  {0,cos(angle),-sin(angle)},
  {0,sin(angle),cos(angle)}};
  
  original = matmul(original, rotationX);
  return original;
}
PVector rz(PVector original, float angle) {
    float[][] rotationZ = {
      {cos(angle),-sin(angle),0},
      {sin(angle),cos(angle),0},
      {0,0,1}};
  
  original = matmul(original, rotationZ);
  return original;
}
PVector ry(PVector original, float angle) {
    float[][] rotationY = {
  {cos(angle),0,sin(angle)},
  {0,1,0},
  {-sin(angle),0,cos(angle)}};
  
  original = matmul(original, rotationY);
  return original;
}
float[] point2lonlat(PVector pos) {
  float lattheta = map(pos.y, 0, height, -HALF_PI, HALF_PI);
  float lonphi = map(pos.x, 0, width, 0, TWO_PI); 
  return new float[] {lonphi, lattheta};
}
PVector lonlat2point(float lon, float lat) {
  float y = map(lat, -HALF_PI, HALF_PI, 0, height);
  float x = map(lon, 0, TWO_PI, 0, width);
  return new PVector(x,y);
}

float[] cart2sphere(PVector point) {
  float lon = atan2(point.x, -point.z);
  float lat = asin(point.y);
  return new float[] {lon, lat};
}
PVector sphere2cart(float lon, float lat) {
  float y = sin(lat);
  float x = sin(lon)*cos(lat);
  float z = -cos(lon)*cos(lat);
  return new PVector(x,y,z);
}
