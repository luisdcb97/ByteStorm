private Board campo;  // tabuleiro de jogo
private float score;  // pontuacao
private boolean lost;  // se o jogador perdeu ou nao

private float restartButtonX;
private float restartButtonY;
private float restartButtonWidth;
private float restartButtonHeight;

private int tam;  // numero de colunas e linhas da board
private float boardSize; // tamanho da board na janela de jogo,
private float padding;  // tamanho do padding em relacao a board
private float slotSize;  // tamanho do slot em relacao a board
private String difficulty; // dificuldade do jogo

void setup(){
  noStroke();  
  size(640, 480);
  
  tam = 4; // numero de colunas e linhas da board
  
  boardSize = 0.6 * min(width, height); // tamanho da board na janela de jogo,
  padding = 0.15 * boardSize/(tam+1);  // tamanho do padding em relacao a board
  slotSize = 0.85 * boardSize/tam;  // tamanho do slot em relacao a board
  
  difficulty = "Normal";
  
  campo = new Board(tam, slotSize, padding, difficulty, color(175), color(200));
  score = 0;
  lost = true;
}

void draw(){
   background(120);
   drawBoard(campo);
   fill(0);
   textSize(32);
   text("Score:" + score, width/2, 50);
   
   if(lost == true){
     defeat();
   }
}

void defeat(){
   fill(255, 150);
   rect(0, 0, width, height);
   fill(0);
   textSize(50);
   text("YOU LOST", width/2, height/2);
   
   
   pushMatrix();
     int border = 3; // button border
     restartButtonWidth = 150;
     restartButtonHeight = 30;
     restartButtonX = width /2 - restartButtonWidth/2;
     restartButtonY = height/2 + restartButtonHeight;
     translate(restartButtonX, restartButtonY); // move a origem do desenho
     fill(0, 0, 125);
     rect(-border, -border, restartButtonWidth + 2*border, restartButtonHeight + 2*border); // dark border
     fill(0, 0, 225);
     rect(0, -3, restartButtonWidth + border, restartButtonHeight + border); // light border
     fill(0, 0, 175);
     rect(0, 0, restartButtonWidth, restartButtonHeight); // button
     fill(255);
     textSize(18);
     textAlign(CENTER, CENTER);
     text("RESTART", restartButtonWidth/2, restartButtonHeight/2);
   popMatrix();
}

void drawBoard(Board tabuleiro){
  float tamanho = (tabuleiro.getTamanho() + 1 ) * tabuleiro.getPadding() + tabuleiro.getTamanho() * tabuleiro.getSlotSize(); // tamanho da board
  
  float boardInitialX = (width - tamanho) / 2; // origem X da board
  float boardInitialY = (height - tamanho) / 2; // origem Y da board
  
  tabuleiro.desenha(boardInitialX, boardInitialY, tamanho);
}

void keyReleased(){
  if(lost){
   return; 
  }
  if( (keyCode == DOWN || keyCode == UP || keyCode == RIGHT || keyCode == LEFT) && campo.canMove(keyCode)){ 
    switch(keyCode){
      case UP:
       score += campo.moveBoardUP();
       break;
      case DOWN:
       score += campo.moveBoardDOWN();
       break;
      case LEFT:
       score += campo.moveBoardLEFT();
       break;
      case RIGHT:
       score += campo.moveBoardRIGHT();
       break;
      default:
    }
     
    campo.randomPiece();
    campo.resetFused();
    
  }
   
   lost = !campo.canMove();
}

void mouseReleased(){
  if(lost && mouseButton == LEFT && mouseX >= restartButtonX && mouseX <= restartButtonX + restartButtonWidth  && mouseY >= restartButtonY && mouseY <= restartButtonY + restartButtonHeight){
    campo = new Board(tam, slotSize, padding, difficulty, color(175), color(200));
    score = 0;
    lost = false;
    
  }
}