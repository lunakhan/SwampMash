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
  else if (gamestate == 1 || gamestate == 2) {
    if (backgroundImg != null) image(backgroundImg, 0, 0, width, height);
    if (b != null) {
      b.display();
      // poll for end conditions
      if (b.isTimeUp() || b.reachedTarget()) endGame();
    }
  }
  else if (gamestate == 3) {
    // game over diaply
    if (backgroundImg != null) image(backgroundImg, 0, 0, width, height);
    if (b != null) b.display();

    rectMode(CORNER);
    fill(0, 200);
    rect(0, 0, width, height);

    textAlign(CENTER, CENTER);
    fill(255);
    textSize(60);
    String msg = (b != null && b.reachedTarget()) ? "You Won!" : "Time's Up!";
    text(msg, width/2, height/2 - 60);
    textSize(36);
    text("Final Score: " + (b != null ? b.score : 0), width/2, height/2);
    textSize(24);
    text("Click to return to menu", width/2, height/2 + 60);

    rectMode(CENTER);
    textAlign(LEFT, BASELINE);
  }
}

void mousePressed() {
  if (gamestate == 0) {
    gamestate = m.processClick(mouseX, mouseY);
    // changed to work for endless mode (hopefully)
    if ((gamestate == 1 || gamestate == 2) && b == null) {
      b = new Board(this, gamestate);
    }
    if (gamestate != 0) {
      print("switching gamestate to: ");
      print(gamestate);
    }
  } else if (gamestate == 1 || gamestate == 2) {
    if (b.handleClick(mouseX, mouseY)) endGame();
  } else if (gamestate == 3) {
    // dismiss game over -> back to menu
    gamestate = 0;
    b = null;
  }
}

void keyPressed() {
  // input only during active gameplay
  if (b != null && (gamestate == 1 || gamestate == 2)) {
    boolean swapped = false;
    if (keyCode == UP)         { b.swapTiles('u'); swapped = true; }
    else if (keyCode == DOWN)  { b.swapTiles('d'); swapped = true; }
    else if (keyCode == LEFT)  { b.swapTiles('l'); swapped = true; }
    else if (keyCode == RIGHT) { b.swapTiles('r'); swapped = true; }
    if (swapped) b.processMatches();
  }
}

void endGame() {
  // "game is over" transitions
  // save once, then show end screen
  if (gamestate != 3 && b != null) {
    b.saveScore();
    gamestate = 3;
  }
}
