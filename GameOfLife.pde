boolean[][] tiles; 
boolean[][] tileBuffer;

int rows = 50;
int cols = 50;

int xScale, yScale = 0;

void setup() {
  // initialize the buffer
  tiles = new boolean[rows][cols];
  tileBuffer = new boolean[rows][cols];
  xScale = width / cols;
  yScale = height / rows;
  size(1000, 1000);
  frameRate(30);
}

void drawTiles() {
  for (int row = 0; row < rows; row++) {
    for (int col = 0; col < cols; col++) {
      int neighbors = getNeighbors(row, col);
      if (tiles[row][col]) {
        rect(col * xScale, row * yScale, xScale, yScale);
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
  }
  drawTiles();
}

void mouseDragged() {
  int constrainedMouseX = Math.max(0, Math.min(width - 1, mouseX));
  int constrainedMouseY = Math.max(0, Math.min(height - 1, mouseY));
  int scaledY = (int)Math.floor(constrainedMouseY / (yScale));
  int scaledX = (int)Math.floor(constrainedMouseX / (xScale));
  tiles[scaledY][scaledX] = mouseButton == LEFT;
}

void keyPressed() {
  if (key == ' ') {
      playing = !playing;
    }
  if (key == 'r' && !playing) {
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        tiles[row][col] = false;
      }
    }
  }
}
