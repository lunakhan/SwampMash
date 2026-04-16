import processing.sound.*;
PImage menuBackground;
PImage albertImg;

class Menu {
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
  int highscore3;
  boolean level2Unlocked;

  //sound variables
  PApplet parent;
  SoundFile uiMusic;
  SoundFile acceptClick;
  SoundFile backClick;

  Menu(PApplet p) {
    //initiaze submenu states, buttons, and highscores
    parent = p;
    instructions = false;
    highscores = false;
    title = new Button(400, 100, 200, 100, "Swamp Mash", 30, 80, color(255));
    easy = new Button(200, 300, 150, 75, "level mode", 20, 55, color(0, 255, 0));
    hard = new Button(600, 300, 150, 75, "endless mode", 20, 65, color(255, 0, 0));
    i = new Button(200, 400, 150, 75, "how to play", 20, 55, color(255, 255, 0));
    h = new Button(600, 400, 150, 75, "highscores", 20, 45, color(0, 255, 255));
    int[]scores = getHighscores();
    highscore1 = scores[0];
    highscore2 = scores[1];

    //load background image
    menuBackground = parent.loadImage("menu_background.png");

    //load albert icon
    albertImg = parent.loadImage("albert.png");

    //load music
    uiMusic = new SoundFile(parent, "Assets/Audio/MenuMusic.wav");
    uiMusic.loop();

    //load sounds
    acceptClick = new SoundFile(parent, "Assets/Audio/Menu1Select.wav");
    backClick = new SoundFile(parent, "Assets/Audio/Menu1Back.wav");

    // load level 2 unlock state
    level2Unlocked = loadUnlockState();
    // re-read scores to also grab level 2 highscore
    refreshHighscores();
  }

  int[] getHighscores() {
    //read scores file and find max value for easy and hard game modes
    //index 0: highscore for level games
    //index 1: highscore for endless games
    int[] ret = {0, 0, 0};
    BufferedReader r = createReader("scores.txt");
    if (r == null) return ret;
    String line = null;
    try {
      while ((line = r.readLine()) != null) {
        String[] score = split(line, ',');
        if (score.length < 2) continue;
        int m = int(score[0]);
        int s = int(score[1]);
        if (m == 1)      ret[0] = max(ret[0], s);
        else if (m == 2) ret[1] = max(ret[1], s);
        else if (m == 4) ret[2] = max(ret[2], s);
      }
    }
    catch (IOException e) {
      e.printStackTrace();
    }
    return ret;
  }

  void display() {
    //display background and colors
    image(menuBackground, 0, 0, width, height);

    //Draw albert in the middle
    if (albertImg != null) {
      imageMode(CENTER);
      float targetW = 300;
      float aspect = (float) albertImg.height / (float) albertImg.width;
      float targetH = targetW * aspect;
      image(albertImg, width/2, height/2 + 160, targetW, targetH);
      imageMode(CORNER);
    }
    //label flips once level 2 is unlocked
    easy.s = level2Unlocked ? "level 2" : "level 1";
    easy.display();
    hard.display();
    i.display();
    h.display();

    //display submenus if state is correct
    if (instructions) {
      fill(255, 255, 0);
      rectMode(CENTER);
      rect(400, 300, 600, 400);
      textSize(30);
      fill(0);
      textAlign(CENTER, CENTER);
      text("Get as high of a score as you can\nwithin the time limit! \n\nUse the mouse to select a tile\n\nAfter selecting a tile, use the arrow\nkeys to swap the tile with an adjacent tile\n\nGet 3 or more in a row to clear tiles!", 400, 300);
    }
    if (highscores) {
      fill(0, 255, 255);
      rectMode(CENTER);
      rect(400, 300, 600, 400);
      textSize(30);
      fill(0);
      textAlign(CENTER, CENTER);
      String hsText = "Level 1 Highscore:\n" + str(highscore1)
        + "\n\nEndless Highscore:\n" + str(highscore2);
      if (level2Unlocked) {
        hsText += "\n\nLevel 2 Highscore:\n" + str(highscore3);
      }
      text(hsText, 400, 300);
    }
  }

  int processClick(float x, float y) {
    //close submenus if open
    if (instructions) {
      instructions = false;
      backClick.play();
      return 0;
    } else if (highscores) {
      highscores = false;
      backClick.play();
      return 0;
    }
    //button functionality
    else {
      if (easy.within(x, y)) {
        acceptClick.play();
        return level2Unlocked ? 4 : 1;   // 4 = level 2, 1 = level 1
      } // start easy game
      if (hard.within(x, y)) {
        acceptClick.play();
        return 2;
      } // start hard game
      if (i.within(x, y)) {
        instructions = true;
        acceptClick.play();
      } // open instuctions submenu
      if (h.within(x, y)) {
        refreshHighscores();   // re-read file so new scores appear
        highscores = true;
        acceptClick.play();
      } // open highscore submenu
      return 0;
    }
  }

  void refreshHighscores() {
    int[] scores = getHighscores();
    highscore1 = scores[0];
    highscore2 = scores[1];
    highscore3 = scores[2];
  }

  boolean loadUnlockState() {
    String[] lines = loadStrings("unlocks.txt");
    if (lines == null || lines.length == 0) return false;
    return lines[0].trim().equals("level2");
  }

  void unlockLevel2() {
    if (level2Unlocked) return;   // already unlocked, no need to rewrite
    level2Unlocked = true;
    saveStrings("unlocks.txt", new String[] { "level2" });
    println("level 2 unlocked!");
  }
}
