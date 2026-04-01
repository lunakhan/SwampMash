class Menu{
  //for displaying submenus
  boolean instructions;
  boolean highscores;
  //menu buttons
  Button title;
  Button easy;
  Button hard;
  Button i;
  Button h;
  //previous highscores
  int highscore1;
  int highscore2;
  
  Menu(){
    //initiaze submenu states, buttons, and highscores
    instructions = false;
    highscores = false;
    title = new Button(400,100,200,100,"Florida Fever", 30, 80, color(255));
    easy = new Button(200,300,150,75,"easy mode", 30, 65, color(0,255,0));
    hard = new Button(600,300,150,75,"hard mode", 30, 65, color(255,0,0));
    i = new Button(200,400,150,75,"how to play", 20, 55, color(255,255,0));
    h = new Button(600,400,150,75,"highscores", 20, 45, color(0,255,255));
    int[]scores = getHighscores();
    highscore1 = scores[0];
    highscore2 = scores[1];
  }
  
  int[] getHighscores(){
    //read scores file and find max value for easy and hard game modes
    //index 0: highscore for easy games
    //index 1: highscore for hard games
    int[] ret = {0,0};
    BufferedReader r = createReader("scores.txt");
    String line = null;
    try{
        while((line = r.readLine()) != null){
          String[] score = split(line, ',');
          if(int(score[0]) == 1) ret[0] = max(ret[0], int(score[1]));
          else if (int(score[0]) == 2) ret[1] = max(ret[1], int(score[1]));
      }
    }
    catch (IOException e) {
      e.printStackTrace();
    }
    return ret;
  }
  
  void display(){
    //display background and colors
    background(50,50,200);
    title.display();
    easy.display();
    hard.display();
    i.display();
    h.display();
    
    //display submenus if state is correct
    if(instructions){
      fill(255, 255, 0);
      rect(400,300,600,400);
      textSize(30);
      fill(0);
      text("Get as high of a score as you can\nwithin the time limit! \n\nUse the mouse to select a tile\n\nAfter selecting a tile, use the arrow\nkeys to swap the tile with an adjacent tile\n\nGet 3 or more in a row to clear tiles!",180,180);
    }
    if(highscores){
      fill(0,255, 255);
      rect(400,300,600,400);
      textSize(30);
      fill(0);
      text("Easy Mode Highscore:\n" + str(highscore1) + "\n\nHard Mode HighScore:\n" + str(highscore2),180,180);
    }
  }
  
  int processClick(float x, float y){
    //close submenus if open
    if(instructions){
      instructions = false;
      return 0;
    }
    else if(highscores){
      highscores = false;
      return 0;
    }
    //button functionality
    else{
      if (easy.within(x,y)) return 1; // start easy game
      if (hard.within(x,y)) return 2; // start hard game
      if(i.within(x,y)) instructions = true; // open instuctions submenu
      if(h.within(x,y)) highscores = true; // open highscore submenu
      return 0;
    }
    
  }
}
