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
  // need to use PApplet to load images? I don't think so, just for sound
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
    //draw yellow background if tile is selected
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (grid[i][j].selected) {
          fill(200, 200, 0);
        } else if ((i + j) % 2 == 0) {
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

  void selectTile(int x, int y) {//player click tile
    //reset all tiles to not selected
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        grid[i][j].setSelect(false);
      }
    }
    //translate to col&row
    int col = (x - boardX) / cellSize;
    int row = (y - boardY) / cellSize;
    //select tile if in range
    if ((col >= 0 && col < cols) && (row >= 0 && row < rows)) {
      grid[col][row].setSelect(true);
    }
  }

  boolean swapTiles(Tile a, Tile b) {//swap tile with button
    return false; //placeholder
  }

  //https://www.geeksforgeeks.org/dsa/flood-fill-algorithm/
  void dfs(int x, int y, ArrayList<Tile> visited, int type) {
    //check if out of bounds or already visited or not same type
    if (x < 0 || x >= cols || y < 0 || y >= rows) return;
    Tile t = grid[x][y];
    if (visited.contains(t) || t.getType() != type) return;

    //add tile to visited and continue DFS
    visited.add(t);
    dfs(x + 1, y, visited, type);
    dfs(x - 1, y, visited, type);
    dfs(x, y + 1, visited, type);
    dfs(x, y - 1, visited, type);
  }

  //idk if this is right
  ArrayList<Tile> findMatches(int x, int y) {
    //check all tiles for matches using DFS
    ArrayList<Tile> matched = new ArrayList<Tile>();
    if (x < 0 || x >= cols || y < 0 || y >= rows) return matched;
    Tile t = grid[x][y];
    dfs(x, y, matched, t.getType());
    return matched;
  }

  int clearMatches(ArrayList<Tile> matched) {//remove matched tiles
    return 0; //placeholder
  }

  void dropTiles() {//tiles falling down
  }
}
