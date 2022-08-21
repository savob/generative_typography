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
}

void scanFromEdges(PGraphics inputGraphics, color textColourIn, color backing) {
  
  // Make everything either text colour or backing
  for (int i = 0; i < inputGraphics.pixels.length; i ++) {
    if (inputGraphics.pixels[i] != backing) inputGraphics.pixels[i] = textColourIn;
  }
  
  color searchFor = backing;
  boolean textEncountered = false;
  int iteration = 0;
  
  do {
    color markWith = color((iteration + 1)*2);
    textEncountered = false;
    
    for (int x = 0; x < inputGraphics.width; x++) {
      for (int y = 0; y < inputGraphics.height; y++) {
        
        // Check for text
        color temp = inputGraphics.pixels[x + inputGraphics.width * y];
        
        if (temp == textColourIn) {
          textEncountered = true;

          // Check if any neighbors are text
          for (int tempx = max(0, x - 1); tempx <= min(inputGraphics.width, x + 1); tempx++) {
            for (int tempy = max(0, y - 1); tempy <= min(inputGraphics.height, y + 1); tempy++) {
              
              temp = inputGraphics.pixels[tempx + inputGraphics.width * tempy];
              
              if (temp == searchFor) {
                inputGraphics.pixels[x + inputGraphics.width * y] = markWith;
              }  
            } 
          }
        }
      }
    } //<>//
    
    iteration++;
    searchFor = markWith;
  } while (textEncountered == true && iteration < 200); // Repeat until no more text is found
  
  
  
  print("Done in", iteration - 1, "iterations \n");
}
