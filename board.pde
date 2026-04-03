// board class - manages 8x8 grid of tiles (tile swapping, match detection, clearing, refilling)

class Board{
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
    Board(PApplet parent){
        rows = 8;
        cols = 8;
        cellSize = 55;
        boardX = 150;
        boardY = 75;

        grid = new Tile[cols][rows];
        selectedTile = null;
        creatureImages = new PImage[8];
        initBoard();
    }

    void initBoard(){// fill grid with random tiles}

    void display(){// draw all tiles on board}

    void selectTile(int c, int r){//player click tile}

    boolean swapTiles(Tile a, Tile b){//swap tile with button}

    ArrayList<Tile> findMatches(){
        // 3+ matching tiles
    }

    int clearMatches(ArrayList<Tile> matched) {//remove matched tiles}

    void dropTiles(){//tiles falling down}
}