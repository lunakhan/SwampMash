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

void setup(){
  size(800,600);
  gamestate = 0;
  m = new Menu(this);
  background = loadImage("background.png");
  background.resize(800,600);
}

void draw(){
  background(150);
  if(gamestate == 0) m.display();
  else if (gamestate == 1){
    background(background);
    for(int i = 0; i < 8; i++){
       Tile t = new Tile(0,0,i);
       t.display(50 + i * 90, 200, 75);
    }
  }
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
