// Tile class - tiles that hold the icon asset (dragonfly, frog, etc.)

class Tile {
  // grid position
  int col;
  int row;

  // 0 = dragonfly, 1 = frog, 2 = fish, 3 = turtle
  // 4 = shoebill, 5 = beaver, 6 = snake, 7 = razorback
  int type;

  boolean selected;
  PImage img;

  Tile(int c, int r, int t) {
    col = c;
    row = r;
    setType(t);
    selected = false;
  }

  void display(int boardX, int boardY, int cellSize) {
    // draw the tile image at its grid position
    img.resize((int)(cellSize/1.25), (int)(cellSize/1.25));
    //add offset to center the image in the cell
    image(img, boardX + (cellSize - img.width) / 2, boardY + (cellSize - img.height) / 2);
  }

  void setPosition(int c, int r) {
    col = c;
    row = r;
  }

  void setType(int newType) {
    // update tile's icon type and image
    type = newType;
    if (type == 0) {
      img = loadImage("Assets/art/dragonfly.png");
    } else if (type == 1) {
      img = loadImage("Assets/art/frog.png");
    } else if (type == 2) {
      img = loadImage("Assets/art/fish.png");
    } else if (type == 3) {
      img = loadImage("Assets/art/turtle.png");
    } else if (type == 4) {
      img = loadImage("Assets/art/shoebill.png");
    } else if (type == 5) {
      img = loadImage("Assets/art/beaver.png");
    } else if (type == 6) {
      img = loadImage("Assets/art/snake.png");
    } else if (type == 7) {
      img = loadImage("Assets/art/razorback.png");
    }
  }

  int getType() {
    return type;
  }

  void setSelect(boolean b) {
    selected = b;
  }


  boolean matches(Tile other) {
    //check if this tile's type = another tile
    return other.getType() == type;
  }
}

Tile getRandomTile() {
  Tile t = new Tile(0, 0, int(random(8)));

  return t;
}
