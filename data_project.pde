import java.io.File;
import java.util.ArrayList;


String density = "Ñ@#W$9876543210?!abc;:+=-,._ ";
ArrayList<String> imagePaths = new ArrayList<String>();
PImage photo = null;
int imgIndex = 0;
int cell = 8; // cell size

void setup () {
  size(800, 800);
  pixelDensity(1);
  listImages();
  if (imagePaths.isEmpty()) {
    println("No images found");
    exit();
  }
  loadPhoto(imgIndex);
  
  
  //photo = loadImage("crime_in_1957.png");
  //photo.resize(width, height);
  //photo.loadPixels();
  textFont(createFont("Monospaced", cell), cell);
  textAlign(CENTER, CENTER);
  noStroke();
}

void draw () {
  background(0);  
  if (photo == null) {
    return;
  }
  colorMode(HSB, 360, 100, 100);
  // sample the center of the cell
  
  
  for (int y = 0; y < height; y += cell) {
    for (int x = 0; x < width; x += cell) {
      int sx = min(x + cell/2, width - 1);
      int sy = min(y + cell/2, height - 1);
      color c = photo.pixels [y * width + x];
      
      
      //float avg = (red(c)+green(c)+blue(c))/3.0;
      float h = hue(c);
      float sat = saturation(c);
      float bri = brightness(c);
      
      
      // map brightness to a character (dark -> dense glyph)
      int di = int(map(bri, 0, 100, density.length()-1, 0));
      di = constrain(di, 0, density.length()-1);
      char ch = density.charAt(di);

      fill(h, sat, bri);
      text(ch, x, y);
    }
  }
  
  
  // when you click the program goes to the next image
}

void mousePressed () {
  if (imagePaths.isEmpty()) {
    return;
  }
  
  imgIndex = (imgIndex + 1) % imagePaths.size();
  loadPhoto(imgIndex);
}

void listImages() {
  File dir = new File(dataPath(""));
  if (!dir.exists()) dir.mkdirs();
  
  File[] files = dir.listFiles();
  
  if (files == null) {
    return;
  } 
  
  for (File f : files) {
    
    
    if (f.getAbsolutePath().endsWith(".png")) {
      println(f.getAbsolutePath());
      imagePaths.add(f.getAbsolutePath());
    }
    
  }
  
}


void loadPhoto(int idx) {
  String path = imagePaths.get(idx);
  photo = loadImage(path);
  //if (path == "/Users/phinhasasmelash/Projects/cmpm_169/data_project/data/.DS_Store") {
  //  // ignore this file
    
  //}
  if (photo == null) {
    println("Could not load: " + path);
    return;
  }
  // Resize to canvas so indexing is 1:1
  photo.resize(width, height);
  photo.loadPixels();
}
