PImage originalMap;
PImage newMap;
// noprotect

int StartingLattitude = -90;
int StartingLongitude = -30;


//  press the run button and when the app loads just press somewhere on the map.
String fileName = "map.png";

// the calculation should take about 10 seconds, if you run it locally it will be much faster.

void setup() {
    println("Started");
    size(1200, 600);
    originalMap = loadImage("source.jpg");
    originalMap.loadPixels();
    // you could even change the source image to another map! Just change the file path between the quotes. And make sure the map is 1200px by 600px (look up image resizer), if your map has another ratio it might be a mercator projection instead of an equirectangular projection, these maps wont work.
    image(originalMap,0,0);
    //for (int i = 1; i<=100; i+=2) {
    //  createMap(min(i,90), 0);
    //  println(i);
    //  save("Gif/image"+str(i)+".png");
    //}
    
}

void draw() {
    
}

void mouseClicked() {
    if (mouseButton != LEFT) {
        println("Drawing the original map");
        background(0);
        image(originalMap,0,0);
        return;
    }
    float[] coordinate = xy2startinglatlon(mouseX, mouseY);
    createMap(coordinate[0], coordinate[1]);
}

void createMap(float lat, float lon) {
    //println("Creating new map");
    newMap = createImage(1200, 600, RGB);
    newMap.loadPixels(); 
    for (int i = 0; i < newMap.pixels.length; i++) {
      PVector pixelP = new PVector(ind2xy(i, width)[0], ind2xy(i, width)[1]);
      float[] coor = point2lonlat(pixelP);
      float lonphi = coor[0];
      float lattheta = coor[1];
  
      PVector unitPoint = sphere2cart(lonphi, lattheta);
          //unitPoint = rx(unitPoint, lon);
          //unitPoint = rz(unitPoint, PI-lat);       
          unitPoint = ry(unitPoint, radians(-lon));
      unitPoint = rx(unitPoint, radians(-lat)); 
      
      
      coor = cart2sphere(unitPoint);
      lonphi = coor[0];
      lattheta = coor[1];
  
      PVector newPoint = lonlat2point(lonphi, lattheta);
  
        int newInd = xy2ind(round(newPoint.x), round(newPoint.y), width);
        float r = red(originalMap.pixels[i]);
        float g = green(originalMap.pixels[i]);
        float b = blue(originalMap.pixels[i]);
    
        newMap.pixels[max(min(newInd, 719999),0)] = color(int(r),int(g),int(b));
    }
    newMap.updatePixels();

    for (int i = 0; i < newMap.pixels.length; i++) {
        if (blue(newMap.pixels[i]) == 0) {
            int x = ind2xy(i,width)[0]; int y = ind2xy(i,width)[1];
            int totr = 0; int totg = 0; int totb = 0; int totam = 0; color col;
            col = newMap.pixels[xy2ind(x+1, y, width)];
            if (green(col) != 0) { totam++;
                totr+=red(col);
                totg+=green(col);
                totb+=blue(col);}
            col = newMap.pixels[xy2ind(x-1, y, width)];
            if (green(col) != 0) { totam++;
                totr+=red(col);
                totg+=green(col);
                totb+=blue(col);}
            col = newMap.pixels[xy2ind(x, y+1,width)];
            if (green(col) != 0) { totam++;
                totr+=red(col);
                totg+=green(col);
                totb+=blue(col);}
            col = newMap.pixels[xy2ind(x, y-1,width)];
            if (green(col) != 0) { totam++;
                totr+=red(col);
                totg+=green(col);
                totb+=blue(col);}
            totam = max(1,totam);
            //if (i%1000 == 0) {println(col);}
            newMap.pixels[i] = color(totr/totam, totg/totam, totb/totam);
        }
    }
    newMap.updatePixels();
    background(0);
    image(newMap,0,0);
    //save(fileName);
    //point(width/2, height/2);
}
int[] ind2xy(int ind, int w) {
    return new int[] {ind%w, int(ind/w)};
}
int xy2ind(int x, int y, int w) {
    return max(min(y*w+x, 719999),0);
}

float[] xy2startinglatlon(int x, int y) {
    float lat = map(y, 0, height, 90, -90);
    float lon = map(x, 0, width, 180, -180);
    return new float[] {lat, lon};
}
