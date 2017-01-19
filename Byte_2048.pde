public Board campo;
public float score;
public boolean lost;

void setup(){
  noStroke();
  size(640, 480);
  
  int tam = 4; // numero de colunas e linhas da board
  
  float boardSize = 0.6 * min(width, height); // tamanho da board na janela de jogo,
  float padding = 0.15 * boardSize/(tam+1);  // tamanho do padding em relacao a board
  float slotSize = 0.85 * boardSize/tam;  // tamanho do slot em relacao a board
  
  campo = new Board(tam, slotSize, padding,"Normal", color(175), color(200));
  score = 0;
  lost = false;
}

void draw(){
   background(120);
   drawBoard(campo);
   fill(0);
   textSize(32);
   text("Score:" + score, width/2, 50);
   if(lost == true){
     fill(255, 150);
     rect(0, 0, width, height);
     fill(0);
     textSize(50);
     text("YOU LOST", width/2, height/2);
   }
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
  if(keyCode == DOWN || keyCode == UP || keyCode == RIGHT || keyCode == LEFT){ 
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
    if(campo.canMove(keyCode)){
      campo.randomPiece();
      campo.resetFused();
    }
  }
   
   lost = !campo.canMove();
}