import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20

public int rate = 6;
public final static int NUM_ROWS = 40;
public final static int NUM_COLS = 60;
private Life[][] buttons; //2d array of Life buttons each representing one cell
private boolean[][] buffer; //2d array of booleans to store state of buttons array
private boolean running = true; //used to start and stop program 
private SimpleButton fpsAdd;
private SimpleButton fpsSub;
private SimpleButton pause;
private SimpleButton wipe;
private SimpleButton randomize;

public void setup () {
  //noStroke();
  size(1200, 920);
  frameRate(rate);
  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new Life[NUM_ROWS][NUM_COLS];
  for(int r = 0; r < NUM_ROWS; r++) {
    for(int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new Life(r, c);
    }
  }
  //your code to initialize buffer goes here
  buffer = new boolean[NUM_ROWS][NUM_COLS];
  fpsAdd = new SimpleButton(150, 820, 40, 40, "+");
  fpsSub = new SimpleButton(90, 820, 40, 40, "-");
  pause = new SimpleButton(1100, 820, 40, 40, "pause");
  wipe = new SimpleButton(950, 820, 40, 40, "wipe");
  randomize = new SimpleButton(800, 820, 40, 40, "random");
}

public void draw () {
  frameRate(rate);
  int tempRate = rate;
  if(running == false) {
    frameRate(30);
  } else {
    frameRate(tempRate);
  }
  background(150);
  if (running == false) //pause the program
    return;
  copyFromButtonsToBuffer();

  //use nested loops to draw the buttons here
  for(int r = 0; r < NUM_ROWS; r++) {
    for(int c = 0; c < NUM_COLS; c++) {
      if(countNeighbors(r, c) == 3) {
        buffer[r][c] = true;
      } else if(countNeighbors(r, c) == 2 && buttons[r][c].getLife() == true) {
        buffer[r][c] = true;
      } else {
        buffer[r][c] = false;
      }
      stroke(0);
      buttons[r][c].draw();
    }
  }
  copyFromBufferToButtons();  
}

public void copyFromBufferToButtons() {
  for(int r = 0; r < NUM_ROWS; r++) {
    for(int c = 0; c < NUM_COLS; c++) {
      buttons[r][c].setLife(buffer[r][c]);
    }
  }
}

public void copyFromButtonsToBuffer() {
  for(int r = 0; r < NUM_ROWS; r++) {
    for(int c = 0; c < NUM_COLS; c++) {
      buffer[r][c] = buttons[r][c].getLife();
    }
  }
}

public boolean isValid(int r, int c) {
  if(r < NUM_ROWS && r >= 0 && c < NUM_COLS && c >= 0) {
    return true;
  } else {
    return false;
  }
}

public int countNeighbors(int row, int col) {
  int count = 0;
  if(isValid(row-1, col) && buttons[row-1][col].getLife()) {
    count++;
  }
  if(isValid(row+1, col) && buttons[row+1][col].getLife()) {
    count++;
  }
  if(isValid(row, col+1) && buttons[row][col+1].getLife()) {
    count++;
  }
  if(isValid(row, col-1) && buttons[row][col-1].getLife()) {
    count++;
  }
  if(isValid(row+1, col+1) && buttons[row+1][col+1].getLife()) {
    count++;
  }
  if(isValid(row-1, col-1) && buttons[row-1][col-1].getLife()) {
    count++;
  }
  if(isValid(row+1, col-1) && buttons[row+1][col-1].getLife()) {
    count++;
  }
  if(isValid(row-1, col+1) && buttons[row-1][col+1].getLife()) {
    count++;
  }
  return count;
}
public class Life {
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean alive;

  public Life (int row, int col) {
    width = 1200/NUM_COLS;
    height = 800/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    alive = Math.random() < .5; // 50/50 chance cell will be alive
    Interactive.add(this); // register it with the manager
  }

  // called by manager
  public void mousePressed () {
    alive = !alive; //turn cell on and off with mouse press
  }
  public void draw () {    
    if (alive != true)
      fill(48, 30, 3);
    else 
      fill(150);
      rect(x, y, width, height);
  }
  public boolean getLife() {
    //replace the code one line below with your code
    return alive;
  }
  public void setLife(boolean living) {
    alive = living;
  }
}
public class SimpleButton {

  private float x, y, width, height;
  private String myID;
  //private int clicks;
  SimpleButton (float xx, float yy, float w, float h, String i) {
    x = xx; 
    y = yy; 
    width = w; 
    height = h;
    myID = i;
    Interactive.add(this); // register it with the manager
  }
  
  void mousePressed () {
    if(myID.equals("+")) {
        if(rate < 30 && running) {
        rate += 4;
      }
    }
    if(myID.equals("-")) {
        if(rate > 2 && running) {
        rate -= 4;
      }
    }
    if(myID.equals("pause")) {
      running = !running;
    }
    if(myID.equals("wipe")) {
      for(int r = 0; r < NUM_ROWS; r++) {
        for(int c = 0; c < NUM_COLS; c++) {
          buttons[r][c].setLife(false);
        }
      }
    }
    if(myID.equals("random")) {
      for(int r = 0; r < NUM_ROWS; r++) {
        for(int c = 0; c < NUM_COLS; c++) {
          double a = (Math.random());
          if(a < 0.5) {
            buttons[r][c].setLife(false);
          } else {
            buttons[r][c].setLife(true);
          }
        }
      }
    }
  }

  void draw () {
    
    fill(255);
    rect(x, y, width, height);
    textAlign(CENTER);
    fill(0);
    if(myID.equals("+")) {
      textSize(40);
      text("+", x + 21, y + 32);
      textAlign(LEFT);
      textSize(24);
      text("Frames per second: " + rate, 20, 900);
    }
    if(myID.equals("-")) {
      textSize(40);
      text("-", x + 21, y + 32);
    }
    if(myID.equals("pause")) {
      textSize(24);
      textAlign(LEFT);
      text("Pause/Play", 1060, 900);
      if(running) {
        rect(x + 10, y + 10, 5, 20);
        rect(x + 25, y + 10, 5, 20);
      } else {
        triangle(x + width/5, y + width/5, x + width/5, y + width-(width/4), x + width-(width/4), y + width/2);
      }
    }
    if(myID.equals("wipe")) {
      textAlign(CENTER);
      fill(255, 0, 0);
      textSize(35);
      text("X", x + 21, y + 33);
      textSize(24);
      fill(0);
      textAlign(LEFT);
      text("Wipe", 945, 900);
    }
    if(myID.equals("random")) {
      ellipse(x + 20, y + 20, 30, 30);
      textAlign(LEFT);
      text("Reset", 790, 900);
    }
  }
}

