boolean[][] tiles; 
boolean[][] tileBuffer;

int rows = 200;
int cols = 200;

float xScale, yScale = 0;
int brushRadius = 10;

void setup() {
  // initialize the buffer
  tiles = new boolean[rows][cols];
  tileBuffer = new boolean[rows][cols];
  xScale = (float)width / (float)cols;
  yScale = (float)height / (float)rows;
  size(600, 600);
  frameRate(30);
}

void drawTiles() {
  for (int row = 0; row < rows; row++) {
    for (int col = 0; col < cols; col++) {
      int neighbors = getNeighbors(row, col);
      if (tiles[row][col]) {
        rect((float)col * xScale, (float)row * yScale, (float)xScale, yScale);
        if (neighbors == 2) {
          tileBuffer[row][col] = true;
          continue;
        }
      }
      if (neighbors == 3) {
        tileBuffer[row][col] = true;
        continue;
      }
      tileBuffer[row][col] = false;
    }
  }
}

int getNeighbors(int row,int col) {
  int neighbors = 0;
  for (int i = row - 1; i < row + 2; i++) {
    // if i is out of bounds, skip
    if (i < 0 || i >= rows) {
      continue;
    }
    for (int j = col - 1; j < col + 2; j++) {
      // if j is out of bounds, or if we are on the current tile, skip
      if (j < 0 || j >= cols || (i == row && j == col)) {
        continue;
      }
      if (tiles[i][j]) {
        neighbors += 1;
      }
    }
  }
  return neighbors;
}

boolean playing = false;

void draw() {
  background(0);

  if (playing) {
    // if we are playing, copy the buffer to tiles
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        tiles[row][col] = tileBuffer[row][col];
      }
    }
  } else {
    // otherwise, display brush preview
    ellipse(mouseX, mouseY, brushRadius * 2 * xScale, brushRadius * 2 * yScale);
  }
  drawTiles();
}

void mouseDragged() {
  float constrainedMouseX = Math.max(0, Math.min(width - 1, mouseX));
  float constrainedMouseY = Math.max(0, Math.min(height - 1, mouseY));
  int scaledY = (int)Math.floor(constrainedMouseY / yScale);
  int scaledX = (int)Math.floor(constrainedMouseX / xScale);
  int brushRadiusSquared = (int)Math.pow(brushRadius, 2);
  for (int row = (scaledY - brushRadius); row < (scaledY + brushRadius); row++) {
    if (row < 0 || row >= rows) {
      continue;
    }
    for (int col = (scaledX - brushRadius); col < (scaledX + brushRadius); col++) {
      if (col < 0 || col >= cols) {
        continue;
      }
      float distSquared = (col - scaledX) * (col - scaledX) + (row - scaledY) * (row - scaledY);
      if (distSquared > brushRadiusSquared) {
        continue;
      }
      tiles[row][col] = mouseButton == LEFT;

    }
  }

}

void keyPressed() {
  if (playing && key != ' ') {
    return;
  }
  switch (key) {
    case ' ':
      playing = !playing;
      break;
    case 'r':
      for (int row = 0; row < rows; row++) {
        for (int col = 0; col < cols; col++) {
          tiles[row][col] = false;
        }
      }
      break;
    case '1':
      brushRadius = 10 / (int)xScale;
      break;
    case '2':
      brushRadius = 20 / (int)xScale;
      break;
    case '3':
      brushRadius = 30 / (int)xScale;
      break;
  }
}
