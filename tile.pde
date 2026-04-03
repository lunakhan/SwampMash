// Tile class - tiles that hold the icon asset (dragonfly, frog, etc.)

class Tile{
    // grid position
    int col;
    int row;

    // 0 = dragonfly, 1 = frog, 2 = fish, 3 = turtle
    // 4 = shoebill, 5 = beaver, 6 = snake, 7 = razorback
    int type; 

    boolean selected;
    PImage img;

    Tile(int c, int r, int t){
        col = c;
        row = r;
        type = t;
        selected = false;
        img = null;
    }

    void display(int boardX, int boardY, int cellSize){
        // draw the tile image at its grid position
    }

    void setType(int newType){
        // update tile's icon type and image
    }

    boolean matches(Tile other){
        check if this tile's type = another tile
    }
}