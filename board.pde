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
    selectedTile = null;
    //translate to col&row
    int col = (x - boardX) / cellSize;
    int row = (y - boardY) / cellSize;
    //select tile if in range
    if ((col >= 0 && col < cols) && (row >= 0 && row < rows)) {
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
    //find horizontal and vertical matches that are 3+ 
    ArrayList<Tile> matched = new ArrayList<Tile>();
    if (x < 0 || x >= cols || y < 0 || y >= rows) return matched;
    int type = grid[x][y].getType();
    
    // run length scan: https://catlikecoding.com/unity/tutorials/prototypes/match-3/
    //find horizontal run bounds
    int left = x;
    int right = x;
    while (left - 1 >= 0 && grid[left - 1][y].getType() == type) left--;
    while (right + 1 < cols && grid[right + 1][y].getType() == type) right++;
    //find vertical run bounds
    int up = y;
    int down = y;
    while (up - 1 >= 0 && grid[x][up - 1].getType() == type) up--;
    while (down + 1 < rows && grid[x][down + 1].getType() == type) down++;
  
    //add horizontal run if 3+ in a row
    if (right - left + 1 >= 3) {
      for (int i = left; i <= right; i++) {
        matched.add(grid[i][y]);
      }
    }
    //add vertical run if 3+ in a column
    if (down - up + 1 >= 3) {
      for (int j = up; j <= down; j++) {
        //skip center tile if already added from horizontal run (L/T shape)
        if (!matched.contains(grid[x][j])) matched.add(grid[x][j]);
      }
    }
  
    return matched;
  }
  
  
  ArrayList<Tile> findAllMatches() {
  //scan entire board
  ArrayList<Tile> all = new ArrayList<Tile>();
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      ArrayList<Tile> m = findMatches(i, j);
      for (int k = 0; k < m.size(); k++) {
        if (!all.contains(m.get(k))) all.add(m.get(k));
      }
    }
  }
  return all;
}

  void processMatches() {
    // find/clear/drop/refill in a loop until there aren't cascades
    ArrayList<Tile> matches = findAllMatches();
    while (matches.size() > 0) {
      print("found a match of size: ");
      println(matches.size());
      clearMatches(matches);
      dropTiles();
      matches = findAllMatches();
    }
  }

  int clearMatches(ArrayList<Tile> matched) {
  //null grid spots of matched tiles
  for (int i = 0; i < matched.size(); i++) {
    Tile t = matched.get(i);
    grid[t.col][t.row] = null;
  }
  return matched.size(); //return count for scoring later
}

  void dropTiles() {
  //for each column, shift non-null tiles down and refill empty spots at top
  for (int i = 0; i < cols; i++) {
    int writeRow = rows - 1;
    //pass from bottom to top
    for (int j = rows - 1; j >= 0; j--) {
      if (grid[i][j] != null) {
        grid[i][writeRow] = grid[i][j];
        grid[i][writeRow].setPosition(i, writeRow);
        writeRow--;
      }
    }
    //fill empty spots up top with new tiles
    while (writeRow >= 0) {
      grid[i][writeRow] = getRandomTile();
      grid[i][writeRow].setPosition(i, writeRow);
      writeRow--;
    }
  }
}
}
