// board class - manages 8x8 grid of tiles (tile swapping, match detection, clearing, refilling)

class Board {
  //grid dimensions
  int rows;
  int cols;

  //timer and scores
  int score;
  int startTimeMs;
  boolean isLevelMode;
  int timeLimitMs;
  int targetScore;
  int mode;   // 1=level1, 2=endless, 4=level2
  Button quitBtn;

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
  Board(PApplet parent, int mode) {
    rows = 8;
    cols = 8;
    cellSize = Constants.cellSize;
    this.mode = mode;
    boardX = 20;
    boardY = height/2 - (cellSize * rows)/2;

    grid = new Tile[cols][rows];
    selectedTile = null;
    creatureImages = new PImage[8];
    initBoard();

    // timer and score
    score = 0;
    isLevelMode = (mode == 1 || mode == 4);
    startTimeMs = millis();
    timeLimitMs = 60000;   // 60 seconds for level mode

    if (mode == 1) targetScore = 50;
    else if (mode == 4) targetScore = 70;
    else targetScore = 0;   // endless

    // quit to save scores into txt
    quitBtn = new Button(700, 380, 160, 55, "Quit & Save", 20, 70, color(200, 50, 50));
  }

  void initBoard() {// fill grid with random tiles
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        grid[i][j] = getRandomTile();
        grid[i][j].setPosition(i, j);
      }
    }

    //check and remove matches
    processMatches(false);
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
    displayHUD();
  }

  void displayHUD() {
    rectMode(CORNER);
    textAlign(LEFT, TOP);

    int hudX = boardX + cols * cellSize + 30;
    int hudY = boardY;

    // score panel
    fill(0, 180);
    rect(hudX - 5, hudY - 5, 180, 70);
    fill(255);
    textSize(22);
    text("Score", hudX, hudY);
    textSize(36);
    text(score, hudX, hudY + 28);

    if (isLevelMode) {
      // timer panel
      int hudY2 = hudY + 90;
      fill(0, 180);
      rect(hudX - 5, hudY2 - 5, 180, 70);
      int secs = timeRemainingMs() / 1000;
      fill(secs <= 10 ? color(255, 80, 80) : color(255));
      textSize(22);
      text("Time", hudX, hudY2);
      textSize(36);
      text(secs + "s", hudX, hudY2 + 28);

      // target panel
      int hudY3 = hudY2 + 90;
      fill(0, 180);
      rect(hudX - 5, hudY3 - 5, 180, 70);
      fill(255);
      textSize(22);
      text("Target", hudX, hudY3);
      textSize(36);
      text(targetScore, hudX, hudY3 + 28);
    }

    // restore default
    quitBtn.display();
    rectMode(CENTER);
    textAlign(LEFT, BASELINE);
  }
  boolean handleClick(int x, int y) {
    // returns true if the player clicked Quit, false otherwise
    if (quitBtn.within(x, y)) return true;
    selectTile(x, y);
    return false;
  }

  void saveScore() {
    // add "mode,score" line to scores.txt
    String newLine = mode + "," + score;

    String[] existing = loadStrings("scores.txt");
    String[] updated;
    if (existing == null || existing.length == 0) {
      updated = new String[] { newLine };
    } else {
      updated = new String[existing.length + 1];
      for (int i = 0; i < existing.length; i++) updated[i] = existing[i];
      updated[existing.length] = newLine;
    }
    saveStrings("scores.txt", updated);
    println("saved score: " + newLine);
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
    if (selectedTile == null) return;
    //grab selected tile info
    int sRow = selectedTile.row;
    int sCol = selectedTile.col;
    //get rid of current selected tile
    selectedTile.setSelect(false);
    selectedTile = null;
    if (c == 'u') {
      if (sRow != 0) { //oob check
        Tile temp = grid[sCol][sRow];
        grid[sCol][sRow] = grid[sCol][sRow - 1];
        grid[sCol][sRow - 1] = temp;
        grid[sCol][sRow - 1].row -= 1;
        grid[sCol][sRow].row += 1;
      }
    }
    if (c == 'd') {
      if (sRow != rows - 1) { //oob check
        Tile temp = grid[sCol][sRow];
        grid[sCol][sRow] = grid[sCol][sRow + 1];
        grid[sCol][sRow + 1] = temp;
        grid[sCol][sRow + 1].row += 1;
        grid[sCol][sRow].row -= 1;
      }
    }
    if (c == 'l') {
      if (sCol != 0) { //oob check
        Tile temp = grid[sCol][sRow];
        grid[sCol][sRow] = grid[sCol - 1][sRow];
        grid[sCol - 1][sRow] = temp;
        grid[sCol - 1][sRow].col -= 1;
        grid[sCol][sRow].col += 1;
      }
    }
    if (c == 'r') {
      if (sCol != cols - 1) { //oob check
        Tile temp = grid[sCol][sRow];
        grid[sCol][sRow] = grid[sCol + 1][sRow];
        grid[sCol + 1][sRow] = temp;
        grid[sCol + 1][sRow].col += 1;
        grid[sCol][sRow].col -= 1;
      }
    }
  }

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

  void processMatches(boolean addToScore) {
    // find/clear/drop/refill in a loop until there aren't cascades
    ArrayList<ArrayList<Tile>> groups = findAllMatchGroups();
    while (groups.size() > 0) {
      // score each match group separately, then flatten to clear
      ArrayList<Tile> allMatched = new ArrayList<Tile>();
      for (int g = 0; g < groups.size(); g++) {
        ArrayList<Tile> group = groups.get(g);
        int pts = scoreForMatch(group.size());
        if (addToScore) {
          score += pts;
        }
        print("match of size ");
        print(group.size());
        print(" -> +");
        print(pts);
        print(" (total: ");
        print(score);
        println(")");
        for (int t = 0; t < group.size(); t++) {
          if (!allMatched.contains(group.get(t))) allMatched.add(group.get(t));
        }
      }
      clearMatches(allMatched);
      dropTiles();
      groups = findAllMatchGroups();
    }
  }

  int scoreForMatch(int n) {
    // 3->3, 4->6, 5->8, 6->10, 7->12, 8->14, then +2 per tile beyond
    if (n < 3) return 0;
    if (n == 3) return 3;
    return 2 * n - 2;
  }

  ArrayList<ArrayList<Tile>> findAllMatchGroups() {
    // each horizontal/vertical run of 3+ is one group (L/T shapes count as two groups, which stacks bonus)
    ArrayList<ArrayList<Tile>> groups = new ArrayList<ArrayList<Tile>>();

    // horizontal runs
    for (int j = 0; j < rows; j++) {
      int i = 0;
      while (i < cols) {
        int runStart = i;
        int type = grid[i][j].getType();
        while (i + 1 < cols && grid[i + 1][j].getType() == type) i++;
        if (i - runStart + 1 >= 3) {
          ArrayList<Tile> run = new ArrayList<Tile>();
          for (int k = runStart; k <= i; k++) run.add(grid[k][j]);
          groups.add(run);
        }
        i++;
      }
    }

    // vertical runs
    for (int i = 0; i < cols; i++) {
      int j = 0;
      while (j < rows) {
        int runStart = j;
        int type = grid[i][j].getType();
        while (j + 1 < rows && grid[i][j + 1].getType() == type) j++;
        if (j - runStart + 1 >= 3) {
          ArrayList<Tile> run = new ArrayList<Tile>();
          for (int k = runStart; k <= j; k++) run.add(grid[i][k]);
          groups.add(run);
        }
        j++;
      }
    }

    return groups;
  }

  int timeRemainingMs() {
    if (!isLevelMode) return -1;
    return max(0, timeLimitMs - (millis() - startTimeMs));
  }

  boolean isTimeUp() {
    return isLevelMode && timeRemainingMs() == 0;
  }
  boolean reachedTarget() {
    return isLevelMode && score >= targetScore;
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
