//main file where game is ran in
int gamestate;
//gamestate keeps track of the current state of the game
//0 = main menu
//1 = play game(levels)
//2 = play game(endless)
//3 = game over

Menu m;

void setup(){
  size(800,600);
  gamestate = 0;
  m = new Menu(this);
}

void draw(){
  background(150);
  if(gamestate == 0) m.display();
}

void mousePressed(){
  if(gamestate == 0) {
    gamestate = m.processClick(mouseX, mouseY);
    if(gamestate != 0) {
      print("switching gamestate to: ");
      print(gamestate);
    }   
  }
}
