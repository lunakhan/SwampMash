class Button {
  //position and size
  int x;
  int y;
  int width;
  int height;
  //for displaying text on buttons
  String s;
  int textSize;
  int pushBack;
  //button color
  color c;

  Button(int tempx, int tempy, int tempwidth, int tempheight, String text, int textS, int tpushBack, color tc) {
    //initialize button based on params
    x = tempx;
    y = tempy;
    width = tempwidth;
    height = tempheight;
    s = text;
    textSize = textS;
    pushBack = tpushBack;
    c = tc;
  }

  boolean within(float tempx, float tempy) {
    //for checking if mouse is clicking button
    if (tempx > x + width / 2 || tempx < x - width / 2) return false;
    else if (tempy > y + height / 2 || tempy < y - height / 2) return false;
    else return true;
  }

  void display() {
    //transform to position and draw rect and text
    rectMode(CENTER);
    stroke(0);
    pushMatrix();
    translate(x, y);
    fill(c);
    rect(0, 0, width, height);
    textSize(textSize);
    fill(0);
    text(s, -pushBack, 0);
    popMatrix();
  }
}
