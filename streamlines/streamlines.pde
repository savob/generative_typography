String textToShow = "Streamlines";
int textSize = 200;
int numberSteams = 2000;
float noiseScale = 0.005;

int minLength = 10;
int maxLength = 20;


void setup() {
  noStroke();
  
  size(3000, 800);
  background(0,0);
  
  // Render text
  PGraphics text = createGraphics(width, height);
  PFont targetFont = createFont("Manjari Bold", textSize);
  
  text.beginDraw();
  text.textFont(targetFont);
  text.background(0);
  text.fill(255);
  text.textAlign(CENTER, CENTER);
  text.text(textToShow, width/2, height/2 + textSize / 3);
  text.endDraw();
  
  
  // Generate streamlines for background
  for (int i = 0; i < numberSteams; i ++) {
    
    int x, y;
    
    do {
      x = int(random(width));
      y = int(random(height));
    } while(text.pixels[x + y * width] != color(255));
    
    streamline test = new streamline(x, y, int(random(minLength, maxLength)));
  
    test.paint();
  }
  
  String filename = textToShow + ".png";
  save(filename);
  println("Saved to file '", filename, "' in sketch folder");
}


class streamline {
  float stepLength = 3;
  float maxWidth = 10;
  float minWidth = stepLength * 2;
  float coneWidth = radians(120); // maximum deviation from heading right
  
  PVector direction, position, nextPos;
  
  color lineColour = color(150, 50);
  int lifespan = -1;
  
  
  streamline() {
    this.position = new PVector(0, random(height));
    this.direction = new PVector(0, 0);
  }
  
  streamline(float startx, float starty, int inputLifespan) {
    this.position = new PVector(startx, starty);
    this.direction = new PVector(0, 0);
    this.lifespan = inputLifespan;
  }
  
  
  void paint() {
    // Paint across screen or just for a bit
    if (lifespan == -1) {
      // If lifespan is -1 then to end of screen
      while (this.position.x <= width) {
        this.progress();
      }
    }
    else {
      while (lifespan > 0) {
        lifespan--;
        this.progress();
      }
    }
  }
  
  void progress() {
    noiseDetail(8,0.6); // Rough noise for direction
    float temp;
    temp = noise(this.position.x * noiseScale, this.position.y *noiseScale) - 0.5; // A random direction, centered
    temp = temp * coneWidth;
    
    
    this.direction.fromAngle(temp, this.direction);
    this.nextPos = this.position.add(this.direction.mult(this.stepLength)); 
    
    temp = noise(this.position.x * noiseScale * 2, this.position.y *noiseScale * 2);
    temp = this.minWidth + temp * (this.maxWidth - this.minWidth);
    
    fill(this.lineColour);
    circle(this.position.x, this.position.y, temp);
    
    this.position.x = this.nextPos.x;
    this.position.y = this.nextPos.y;
  }
}
