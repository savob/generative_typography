String textToShow = "Streamlines";
int textSize = 200;
int numberSteams = 300;
float noiseScale = 0.001;



void setup() {
  noStroke();
  
  size(3000, 800);
  background(0,0);
  
  
  // Generate streamlines for background
  for (int i = 0; i < numberSteams; i ++) {
    streamline test = new streamline(0, i * (height / numberSteams));
  
    test.paint();
  }
  
  // Cut out text using a graphic overlay
  PGraphics text = createGraphics(width, height);
  
  // Create the font
  PFont targetFont = createFont("Manjari Bold", textSize);
  
  
  text.beginDraw();
  text.textFont(targetFont);
  text.background(0);
  text.fill(255);
  text.textAlign(CENTER, CENTER);
  text.text(textToShow, width/2, height/2 + textSize / 3);
  text.endDraw();
  redraw();
  
  // Cut out
  loadPixels();
  for (int i = 0; i < text.pixels.length; i ++) {
    if (text.pixels[i] == color(0)) pixels[i] = color(0, 0);
  }
  updatePixels();
  
  String filename = textToShow + ".png";
  save(filename);
  println("Saved to file '", filename, "'");
}



class streamline {
  float stepLength = 3;
  float maxWidth = 10;
  float minWidth = stepLength * 2;
  float coneWidth = radians(90); // maximum deviation from heading right
  
  PVector direction, position, nextPos;
  
  color lineColour = color(150, 50);
  
  
  streamline() {
    position = new PVector(0, random(height));
    direction = new PVector(0, 0);
  }
  
  streamline(float startx, float starty) {
    position = new PVector(startx, starty);
    direction = new PVector(0, 0);
  }
  
  
  void paint() {
    // Paint across screen
    while (this.position.x <= width) {
      
      noiseDetail(8,0.6); // Rough noise for direction
      float temp;
      temp = noise(this.position.x * noiseScale, this.position.y *noiseScale) - 0.5; // A random direction, centered
      temp = temp * coneWidth;
      
      
      this.direction.fromAngle(temp, this.direction);
      
      this.nextPos = this.position.add(this.direction.mult(this.stepLength)); 

      fill(this.lineColour);
      
      
      temp = noise(this.position.x * noiseScale * 2, this.position.y *noiseScale * 2);
      temp = this.minWidth + temp * (this.maxWidth - this.minWidth);
      circle(this.position.x, this.position.y, temp);
      
      this.position.x = this.nextPos.x;
      this.position.y = this.nextPos.y;
    }
  }
}
