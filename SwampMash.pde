//main file where game is ran in
int gamestate;
//gamestate keeps track of the current state of the game
//0 = main menu
//1 = play game(levels)
//2 = play game(endless)
//3 = game over

Menu m;
Board b;
PImage background;

public class Constants {
  static final int cellSize = 55;
}

void setup() {
  size(800, 600);
  gamestate = 0;
  m = new Menu(this);
  background = loadImage("background.png");
  background.resize(800, 600);
}

void draw() {
  background(150);
  if (gamestate == 0) m.display();
  else if (gamestate == 1) {
    background(background);
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
}