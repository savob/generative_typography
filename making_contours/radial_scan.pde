

float radialScan(PGraphics base, color targetColour, int startx, int starty) {
  
  
  if (base.pixels[startx + base.width * starty] == targetColour) return 0.0;
  
  // Find limits on search radius
  float maximumRadius = dist(0,0, base.width - 1, base.height - 1);
  float currentRadius = 1.0;
  float distance = maximumRadius; // Base value, return if it fails to find target colour
  
  do {
    
    // Work down
    for (float i = currentRadius; i > 0; i--) {
      int dA = int(i);
      int dBcur = floor(sqrt(pow(currentRadius,2) - pow(i,2)));
      int dBprev = floor(sqrt(pow(currentRadius - 1,2) - pow(i,2)));
      
      // These deltas are used to mark which indexes to search from 
      
      for (int dB = dBprev; dB <= dBcur; dB++) {
        // Scan in all four quadrants
        distance = min(distance, checkPositions(base, targetColour, startx, starty, startx + dA, starty + dB));
        distance = min(distance, checkPositions(base, targetColour, startx, starty, startx + dA, starty - dB));
        distance = min(distance, checkPositions(base, targetColour, startx, starty, startx - dA, starty + dB));
        distance = min(distance, checkPositions(base, targetColour, startx, starty, startx - dA, starty - dB));
      }
    }
    
    // If the minimum distance has changed, return it!
    if (distance < maximumRadius) return distance;
  } while (currentRadius < maximumRadius);
  
  return -1; // Returns an error
}

float checkPositions(PGraphics map, color searched, int basex, int basey, int x, int y) {
  if (x < 0 || x >= map.width || y < 0 || y >= map.height) return float(1000000);
  
  if (map.pixels[x + map.width * y] == searched) return dist(x, y, basex, basey);
  return float(1000000);
}
