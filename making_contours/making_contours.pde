PFont targetFont;
int textSize = 600;

PGraphics base;

color textColour = color(255);
color backingColour = color(0);

void settings() {
  size((textSize*5)/3, (textSize*5)/3);
}

void setup() {
  base = createGraphics(width, height);

  // Create the font
  targetFont = createFont("Manjari Bold", textSize);
  
  textAlign(CENTER, CENTER);
  frameRate(1);
} 

void draw() {
  base.beginDraw();
  base.background(backingColour);

  base.textFont(targetFont);
  base.textAlign(CENTER, CENTER);
  base.fill(textColour);
  base.text("A", width/2, height/2 + textSize/3);
  base.endDraw();
  
  scanFromEdges(base, textColour, backingColour);
  
  image(base, 0, 0);
  //saveFrame("improved distance calculations.png");
}

void scanFromEdges(PGraphics inputGraphics, color textColourIn, color backing) {
  
  // Make everything either text colour or backing
  for (int i = 0; i < inputGraphics.pixels.length; i ++) {
    if (inputGraphics.pixels[i] != backing) inputGraphics.pixels[i] = textColourIn;
  }
  
  color searchFor = backing;
  boolean textEncountered = false;
  int iteration = 0;
  
  // Make an array to record all distances
  float[][] distances = new float[inputGraphics.width][inputGraphics.height];
  
  do {
    color markWith = color((iteration + 1)*2);
    textEncountered = false;
    
    for (int x = 0; x < inputGraphics.width; x++) {
      for (int y = 0; y < inputGraphics.height; y++) {
        
        // Check for text
        color temp = inputGraphics.pixels[x + inputGraphics.width * y];
        
        if (temp == searchFor) {
          textEncountered = true;

          // Check if any neighbors are not backing
          for (int tempx = max(0, x - 1); tempx <= min(inputGraphics.width - 1, x + 1); tempx++) {
            for (int tempy = max(0, y - 1); tempy <= min(inputGraphics.height - 1, y + 1); tempy++) {
              
              temp = inputGraphics.pixels[tempx + inputGraphics.width * tempy];
              
              if (temp != backing) {
                
                // Record distance, going for minimum. Mark previously scanned pixels for rescanning as needed
                float distanceTemp = distances[x][y] + dist(x, y, tempx, tempy);
                
                if (distances[tempx][tempy] == 0) {
                  distances[tempx][tempy] = distanceTemp; // Zero is an unitialized cell, so put anything
                  inputGraphics.pixels[tempx + inputGraphics.width * tempy] = markWith;
                }
                else if (distances[tempx][tempy] > distanceTemp) {
                  // Mark a previously scanned pixel for re-evaluation if needed
                  distances[tempx][tempy] = distanceTemp;
                  inputGraphics.pixels[tempx + inputGraphics.width * tempy] = markWith;
                }
              }  
            } 
          }
        }
      }
    }
    
    iteration++;
    searchFor = markWith;
  } while (textEncountered == true && iteration < 200); // Repeat until no more text is found
  
  // Find maximum distance
  float maxDistance = 0;
   for (int scanx = 0; scanx < inputGraphics.width; scanx++) {
    for (int scany = 0; scany < inputGraphics.height; scany++) {

      if (distances[scanx][scany]>maxDistance) { 
        maxDistance = distances[scanx][scany];
      }
    }
  }
  
  float scalingFactor = 255.0 / maxDistance; // Find factor to scale distance to full scale in grayscale
  for (int x = 0; x < inputGraphics.width; x++) {
    for (int y = 0; y < inputGraphics.height; y++) {
      inputGraphics.pixels[x + inputGraphics.width * y] = color(scalingFactor * distances[x][y]);
    }
  }
  
  print("Done in", iteration - 1, "iterations. ");
  println("Max distance found: ", maxDistance);
}
