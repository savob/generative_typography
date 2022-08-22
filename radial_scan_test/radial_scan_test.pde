
void setup() {
  size(200,200);
  frameRate(50);
}

void draw() {
  PGraphics test = createGraphics(200,200);
  int x = int(random(199));
  int y = int(random(199));
  
  
  test.beginDraw();
  test.background(color(0));
  test.endDraw();
  test.pixels[x + (y * test.width)] = color(200);
  test.pixels[100 + (100 * test.width)] = color(255,0,0);
  
  image(test, 0,0); // Show test for visuals
  
  float distance = radialScan(test, color(200), 100, 100);
  float expected = dist(100,100, x,y);
  // Compare results
  if (expected == distance) println("X:", x, "\tY:", y, "\tCORRECT! Dist.:", expected);
  else println("ERROR: X:", x, "\tY:", y, "\tExp. Dist.:", expected, "\tFound Dist.:", distance);
}

  
