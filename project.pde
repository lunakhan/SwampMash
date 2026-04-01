
int gamestate;
//gamestate keeps track of the current state of the game
//0 = main menu
//1 = play game(easy)
//2 = play game(hard)
//3 = game over

//menu before game starts
Menu m;

void setup(){
  size(800,600);
  gamestate = 0;
  m = new Menu();
}

//drawing will be handled by seperate classes
void draw(){
  background(150);
  if(gamestate == 0) m.display();
}

//input will be handled by seperate classes
void mousePressed(){
  if(gamestate == 0) {
    gamestate = m.processClick(mouseX, mouseY);
    if(gamestate != 0) {
      print("switching gamestate to: ");
      print(gamestate);
    }   
  }
}
