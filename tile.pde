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
        setType(t);
        selected = false;
    }

    void display(int boardX, int boardY, int cellSize){
        // draw the tile image at its grid position
        img.resize(cellSize,cellSize);
        image(img, boardX, boardY);
    }
    
    void setPosition(int c, int r){
      col = c;
      row = r;
    }

    void setType(int newType){
        // update tile's icon type and image
        type = newType;
      if(type == 0){
        img = loadImage("dragonfly.png");
      }
      else if(type == 1){
        img = loadImage("frog.png");
      }
      else if(type == 2){
        img = loadImage("fish.png");
      }
      else if(type == 3){
        img = loadImage("turtle.png");
      }
      else if(type == 4){
        img = loadImage("shoebill.png");
      }
      else if(type == 5){
        img = loadImage("beaver.png");
      }
      else if(type == 6){
        img = loadImage("snake.png");
      }
      else if(type == 7){
        img = loadImage("razorback.png");
      }
    }
    
    int getType(){return type;}
    

    boolean matches(Tile other){
        //check if this tile's type = another tile
        return other.getType() == type;
    }
}

Tile getRandomTile(){
  Tile t = new Tile(0,0,int(random(8)));
  
  return t;
}
