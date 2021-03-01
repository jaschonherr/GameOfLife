import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20

public int rate = 6;
public final static int NUM_ROWS = 40;
public final static int NUM_COLS = 40;
private Life[][] buttons; //2d array of Life buttons each representing one cell
private boolean[][] buffer; //2d array of booleans to store state of buttons array
private boolean running = true; //used to start and stop program

public void setup () {
  size(800, 850);
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
}

public void draw () {
  frameRate(rate);
  background( 0 );
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
      buttons[r][c].draw();
    }
  }
  copyFromBufferToButtons();
  fill(255);
  textSize(24);
  text(rate + " frames per second", 10, 840);
}

public void keyPressed() {
  if(key == 'p') {
    running = !running;
  }
  if(key == 'd') {
    if(rate < 30) {
      rate += 4;
    }
  }
  if(key == 'a') {
    if(rate > 6) {
      rate -= 4;
    }
  }
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
    width = 800/NUM_COLS;
    height = 800/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    alive = Math.random() < .5; // 50/50 chance cell will be alive
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () {
    alive = !alive; //turn cell on and off with mouse press
  }
  public void draw () {    
    if (alive != true)
      fill(0);
    else 
      fill(255);
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
