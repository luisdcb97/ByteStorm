public Board campo;
public float score;

void setup(){
  noStroke();
  size(640, 480);
  
  int tam = 4; // numero de colunas e linhas da board
  
  float boardSize = 0.6 * min(width, height); // tamanho da board na janela de jogo,
  float padding = 0.15 * boardSize/(tam+1);  // tamanho do padding em relacao a board
  float slotSize = 0.85 * boardSize/tam;  // tamanho do slot em relacao a board
  
  campo = new Board(tam, slotSize, padding,"Normal", color(175), color(200));
  score = 0;
}

void draw(){
   background(120);
   drawBoard(campo);
   fill(0);
   textSize(32);
   text("Score:" + score, width/2, 50);
}

void drawBoard(Board tabuleiro){
  float tamanho = (tabuleiro.getTamanho() + 1 ) * tabuleiro.getPadding() + tabuleiro.getTamanho() * tabuleiro.getSlotSize(); // tamanho da board
  
  float boardInitialX = (width - tamanho) / 2; // origem X da board
  float boardInitialY = (height - tamanho) / 2; // origem Y da board
  
  tabuleiro.desenha(boardInitialX, boardInitialY, tamanho);
}

void keyReleased(){
 switch(keyCode){
  case UP:
   score += campo.moveBoardUP();
   campo.randomPiece();
   break;
  case DOWN:
   score += campo.moveBoardDOWN();
   campo.randomPiece();
   break;
  default:
 }
}