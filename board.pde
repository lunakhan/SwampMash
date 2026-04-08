// board class - manages 8x8 grid of tiles (tile swapping, match detection, clearing, refilling)

class Board {
  //grid dimensions
  int rows;
  int cols;

  //2D array of tiles
  Tile[][] grid;

  PImage[] creatureImages;

  //board positions and changeable cell sizes
  int boardX;
  int boardY;
  int cellSize;

  // tracks which tile player selects
  Tile selectedTile;

  // Constructor - initializes the board with random tiles
  // need to use PApplet to load images?
  Board(PApplet parent) {
    rows = 8;
    cols = 8;
    cellSize = Constants.cellSize;
    boardX = 20;
    boardY = height/2 - (cellSize * rows)/2;

    grid = new Tile[cols][rows];
    selectedTile = null;
    creatureImages = new PImage[8];
    initBoard();
  }

  void initBoard() {// fill grid with random tiles
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        grid[i][j] = getRandomTile();
        grid[i][j].setPosition(i, j);
      }
    }
  }

  void display() {// draw all tiles on board
    //draw a simple grid background with alternating checkerboard pattern
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if ((i + j) % 2 == 0) {
          fill(100);
        } else {
          fill(150);
        }
        rect(boardX + cellSize/2 + i * cellSize, boardY + cellSize/2 + j * cellSize, cellSize, cellSize);
      }
    }

    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        grid[i][j].display(boardX + i * cellSize, boardY + j * cellSize, cellSize);
      }
    }
  }

  void selectTile(int c, int r) {//player click tile
  }

  boolean swapTiles(Tile a, Tile b) {//swap tile with button
    return false; //placeholder
  }

  ArrayList<Tile> findMatches() {
    // 3+ matching tiles
    return new ArrayList<Tile>(); //placeholder
  }

  int clearMatches(ArrayList<Tile> matched) {//remove matched tiles
    return 0; //placeholder
  }

  void dropTiles() {//tiles falling down
  }
}
