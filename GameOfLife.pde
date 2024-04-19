public boolean[][] tiles;
public boolean[][] tileBuffer;

// feel free to change these before the program runs
public static final int NUM_ROWS = 500;
public static final int NUM_COLS = 500;

public float xScale, yScale = 0;
public float brushRadius = 1;

public void setup() {
  // set the size to whatever fits your screen! The game will adapt!
  size(1200, 1200);
  // initialize the buffers
  tiles = new boolean[NUM_ROWS][NUM_COLS];
  tileBuffer = new boolean[NUM_ROWS][NUM_COLS];
  xScale = (float)width / (float)NUM_COLS;
  yScale = (float)height / (float)NUM_ROWS;
}

public void drawTiles() {
  for (int row = 0; row < NUM_ROWS; row++) {
    for (int col = 0; col < NUM_COLS; col++) {
      int neighbors = countNeighbors(row, col);
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

public int countNeighbors(int row, int col) {
  int neighbors = 0;
  for (int i = row - 1; i < row + 2; i++) {
    for (int j = col - 1; j < col + 2; j++) {
      // if j is out of bounds, or if we are on the current tile, skip
      if (!isValid(i, j) || (i == row && j == col)) {
        continue;
      }
      if (tiles[i][j]) {
        neighbors += 1;
      }
    }
  }
  return neighbors;
}

public boolean isValid(int row, int col) {
  return (
    (row < NUM_ROWS && row >= 0) &&
    (col < NUM_COLS && col >= 0)
  );
}

public boolean playing = false;

public void draw() {
  background(0);

  if (playing) {
    // if we are playing, copy the buffer to the tiles
    copyFromBufferToTiles();
    frameRate(15);
  } else {
    frameRate(200);
    // otherwise, display brush preview
    ellipse(mouseX, mouseY, brushRadius * 2 * xScale, brushRadius * 2 * yScale);
    handleMouse();
  }
  drawTiles();
}

public void copyFromTilesToBuffer() {
  for (int row = 0; row < NUM_ROWS; row++) {
    for (int col = 0; col < NUM_COLS; col++) {
      tileBuffer[row][col] = tiles[row][col];
    }
  }
}

public void copyFromBufferToTiles() {
  for (int row = 0; row < NUM_ROWS; row++) {
    for (int col = 0; col < NUM_COLS; col++) {
      tiles[row][col] = tileBuffer[row][col];
    }
  }
}

public void handleMouse() {
  if (!mousePressed) {
    return;
  }
  // make sure the mouseX and mouseY are constrained to the screen to prevent out of bounds
  float constrainedMouseX = Math.max(0, Math.min(width - 1, mouseX));
  float constrainedMouseY = Math.max(0, Math.min(height - 1, mouseY));
  // scale the mouseX and mouseY to the grid
  int scaledY = (int)Math.floor(constrainedMouseY / yScale);
  int scaledX = (int)Math.floor(constrainedMouseX / xScale);

  int brushRadRounded = (int)Math.ceil(brushRadius);
  double brushRadiusSquared = brushRadius * brushRadius;

  for (int row = (scaledY - brushRadRounded); row <= (scaledY + brushRadRounded); row++) {
    for (int col = (scaledX - brushRadRounded); col <= (scaledX + brushRadRounded); col++) {
      if (!isValid(row, col)) {
        continue;
      }
      // distance squared for optimized checking
      float distSquared = (col - scaledX) * (col - scaledX) + (row - scaledY) * (row - scaledY);
      if (distSquared > brushRadiusSquared) {
        continue;
      }
      tiles[row][col] = mouseButton == LEFT;
    }
  }
}

public void keyPressed() {
  if (playing && key != ' ') {
    return;
  }
  switch (key) {
  case ' ':
    playing = !playing;
    break;
  case 'r':
    for (int row = 0; row < NUM_ROWS; row++) {
      for (int col = 0; col < NUM_COLS; col++) {
        tiles[row][col] = false;
      }
    }
    break;
  case '1':
    brushRadius = 10 / xScale;
    break;
  case '2':
    brushRadius = 20 / xScale;
    break;
  case '3':
    brushRadius = 30 / xScale;
    break;
  case '4':
    brushRadius = 40 / xScale;
    break;
  case '5':
    brushRadius = 70 / xScale;
    break;
  case '6':
    brushRadius = 120 / xScale;
    break;
  case '0':
    brushRadius = 0.5;
    break;
  }
}
