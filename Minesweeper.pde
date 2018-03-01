

import de.bezier.guido.*;
public final static int NUM_BOMBS = 30;
public final static  int NUM_ROWS = 20;
public final static  int NUM_COLS = 20;
private MSButton[][] buttons; 
private ArrayList <MSButton> bombs = new ArrayList <MSButton>();  

void setup ()
{
    size(500, 500);
    textAlign(CENTER,CENTER);
    // make the manager
    Interactive.make( this );
    buttons = new MSButton[NUM_ROWS][NUM_COLS];

    for (int r = 0; r < NUM_ROWS; r++){
        for (int c = 0; c < NUM_COLS; c ++){
            buttons[r][c] = new MSButton(r,c);
        }
    }

    for (int i = 0; i < NUM_BOMBS; i ++){
        setBombs();
    }
  }

public void setBombs()
{
        int r = (int)(Math.random()*NUM_ROWS);
        int c = (int)(Math.random()*NUM_COLS);

        if (!bombs.contains(buttons[r][c]))
        {
            bombs.add(buttons[r][c]);
        }
}

public void draw ()
{
    background( 0 );
    if(isWon())
    {
        displayWinningMessage();
        System.out.println("win");
    }
     for (int r = 0; r < NUM_ROWS; r++){
        for (int c = 0; c < NUM_COLS; c ++){
            if ((buttons[r][c].isClicked())&&(bombs.contains(buttons[r][c])))
                displayLosingMessage();
        }
    }
}

public boolean isWon()
{
    int totalSquares =NUM_BOMBS;
    
    for (int r = 0; r < NUM_ROWS; r++){
        for (int c = 0; c < NUM_COLS; c ++){
                if (buttons[r][c].isClicked())
                totalSquares ++;
        }
    }

   if(totalSquares == NUM_ROWS*NUM_COLS){
              
            return true;

        }
    return false;
}
public void displayLosingMessage()
{
    int posY = (NUM_ROWS/2) - 1;
    int posX = (NUM_COLS -10) /2;
    buttons[posY][posX + 1].setLabel("Y");
    buttons[posY][posX + 2].setLabel("O");
    buttons[posY][posX + 3].setLabel("U");
    buttons[posY][posX + 4].setLabel(" ");
    buttons[posY][posX + 5].setLabel("L");
    buttons[posY][posX + 6].setLabel("O");
    buttons[posY][posX + 7].setLabel("S");
    buttons[posY][posX + 8].setLabel("E");
    buttons[posY][posX + 9].setLabel("!");
    noLoop();
}
public void displayWinningMessage()
{     int posY = (NUM_ROWS/2) - 1;
    int posX = (NUM_COLS -10) /2;
    buttons[posY][posX + 1].setLabel("Y");
    buttons[posY][posX + 2].setLabel("O");
    buttons[posY][posX + 3].setLabel("U");
    buttons[posY][posX + 4].setLabel(" ");
    buttons[posY][posX + 5].setLabel("W");
    buttons[posY][posX + 6].setLabel("I");
    buttons[posY][posX + 7].setLabel("N");
    buttons[posY][posX + 8].setLabel("!");
    noLoop();
}



public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 500/NUM_COLS;
        height = 500/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        if ((keyPressed == true)&&(marked== true))
        {
            marked = false;
            clicked = false;
        }
        else if ((keyPressed == true)&&(marked == false))
            marked = true;
        else if (bombs.contains(this))
            displayLosingMessage();
        else if (this.countBombs(r,c)>0)
        {
            int numBomb = this.countBombs(r,c);
            setLabel("" + numBomb);
        }
        else
        {
        if ((isValid(r +1,c+1))&&(buttons[r+1][c+1].isClicked() ==false))
            buttons[r+1][c+1].mousePressed();
        if ((isValid(r -1,c+1))&&(buttons[r-1][c+1].isClicked() ==false))
            buttons[r-1][c+1].mousePressed();
         if ((isValid(r,c+1))&&(buttons[r][c+1].isClicked() == false))
            buttons[r][c+1].mousePressed();
        if ((isValid(r +1,c-1))&&(buttons[r+1][c-1].isClicked() ==false))
           buttons[r+1][c-1].mousePressed();
        if ((isValid(r,c-1))&&(buttons[r][c-1].isClicked() == false))
            buttons[r][c-1].mousePressed();
         if ((isValid(r -1,c-1))&&(buttons[r-1][c-1].isClicked() == false))
            buttons[r-1][c-1].mousePressed();
         if ((isValid(r +1,c))&&(buttons[r+1][c].isClicked() == false))
            buttons[r+1][c].mousePressed();
         if ((isValid(r -1,c))&&(buttons[r-1][c].isClicked() == false))
            buttons[r-1][c].mousePressed();
            /*for (int i = -1; i <=1; i++){
                for (int j = -1; j <=1; j++){
                    if ((isValid(r +i,c+j))&&(buttons[r+i][c+j].isClicked() == false)) 
                        mousePressed();
                }
            }*/
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill(116,198,162);
        else 
            fill( 49,134,96 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if ((r <NUM_ROWS)&&(r >= 0)&&(c<NUM_COLS)&&(c>=0))
                return true;
        return false;
    }
    public int countBombs(int row, int col)
    {
        
        int numBombs = 0;
        if ((isValid(row +1,col+1))&&(bombs.contains(buttons[row+1][col+1])))
            numBombs ++;
        if ((isValid(row -1,col+1))&&(bombs.contains(buttons[row-1][col+1])))
            numBombs ++;
         if ((isValid(row,col+1))&&(bombs.contains(buttons[row][col+1])))
            numBombs ++;
        if ((isValid(row +1,col-1))&&(bombs.contains(buttons[row+1][col-1])))
            numBombs ++;
        if ((isValid(row,col-1))&&(bombs.contains(buttons[row][col-1])))
            numBombs ++;
         if ((isValid(row -1,col-1))&&(bombs.contains(buttons[row-1][col-1])))
            numBombs ++;
         if ((isValid(row +1,col))&&(bombs.contains(buttons[row+1][col])))
            numBombs ++;
         if ((isValid(row -1,col))&&(bombs.contains(buttons[row-1][col])))
            numBombs ++;
        /*
        for (int i = -1; i <=1; i++){
            for (int j = -1; i <=1; i++){
                if ((isValid(row +i,col+j))&&(bombs.contains(buttons[row+i][col+j]))) 
                    numBombs ++;
            }
        }*/
        return numBombs;

    }
}



