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
        if(grid[i][j].selected){
          fill(200,200,0);
        }
        else if ((i + j) % 2 == 0) {
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
    selectedTile = null;
    //translate to col&row
    int col = (x - boardX) / cellSize;
    int row = (y - boardY) / cellSize;
    //select tile if in range
    if((col >= 0 && col < cols) && (row >= 0 && row < rows)){
      grid[col][row].setSelect(true);
      selectedTile = grid[col][row];
    }
  }

  void swapTiles(char c) {//swap tile with button
    //ignore if no tile selected
    if(selectedTile == null) return;
    //grab selected tile info
    int sRow = selectedTile.row;
    int sCol = selectedTile.col;
    //get rid of current selected tile
    selectedTile.setSelect(false);
    selectedTile = null;
    if(c == 'u'){
      if(sRow != 0){ //oob check
        Tile temp = grid[sCol][sRow];
        grid[sCol][sRow] = grid[sCol][sRow - 1];
        grid[sCol][sRow - 1] = temp;
        grid[sCol][sRow - 1].row -= 1;
        grid[sCol][sRow].row += 1;
      }
    }
    if(c == 'd'){
      if(sRow != rows - 1){ //oob check
        Tile temp = grid[sCol][sRow];
        grid[sCol][sRow] = grid[sCol][sRow + 1];
        grid[sCol][sRow + 1] = temp;
        grid[sCol][sRow + 1].row += 1;
        grid[sCol][sRow].row -= 1;
      }
    }
    if(c == 'l'){
      if(sCol != 0){ //oob check
        Tile temp = grid[sCol][sRow];
        grid[sCol][sRow] = grid[sCol - 1][sRow];
        grid[sCol - 1][sRow] = temp;
        grid[sCol - 1][sRow].col -= 1;
        grid[sCol][sRow].col += 1;
      }
    }
    if(c == 'r'){
      if(sCol != cols - 1){ //oob check
        Tile temp = grid[sCol][sRow];
        grid[sCol][sRow] = grid[sCol + 1][sRow];
        grid[sCol + 1][sRow] = temp;
        grid[sCol + 1][sRow].col += 1;
        grid[sCol][sRow].col -= 1;
      }
    }
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
