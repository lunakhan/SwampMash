//main file where game is ran in
int gamestate;
//gamestate keeps track of the current state of the game
//0 = main menu
//1 = play game(levels)
//2 = play game(endless)
//3 = game over

Menu m;
Board b;
PImage backgroundImg;

public class Constants {
  static final int cellSize = 70;
}

void setup() {
  size(800, 600);
  gamestate = 0;
  m = new Menu(this);
  backgroundImg = loadImage("background.png");
}

void draw() {
  background(150);
  if (gamestate == 0) m.display();
  else if (gamestate == 1) {
    //changed bcz I was getting an error w/macbook screen for some reason idk
    if (backgroundImg != null) {
      image(backgroundImg, 0, 0, width, height);
    }
    if (b != null) {
      b.display();
    }
  }
}

void mousePressed() {
  if (gamestate == 0) {
    gamestate = m.processClick(mouseX, mouseY);
    if ((gamestate == 1) && b == null) {
      b = new Board(this);
    }
    if (gamestate != 0) {
      print("switching gamestate to: ");
      print(gamestate);
    }
  }
  else if(gamestate == 1 || gamestate == 2){
    b.selectTile(mouseX,mouseY);
  }
}

void keyPressed(){
  //only works if in gameplay
  if(b != null){
    //pass to board if arrow key
    if(keyCode == UP) b.swapTiles('u');
    else if(keyCode == DOWN) b.swapTiles('d');
    else if(keyCode == LEFT) b.swapTiles('l');
    else if(keyCode == RIGHT) b.swapTiles('r');
  }
}
