import java.util.Hashtable;

private Board campo;  // tabuleiro de jogo
private float score;  // pontuacao
private float memoryCap;  // maximo score possivel
private float levelCap; // score necessario para subir de nivel

private boolean lost;  // se o jogador perdeu ou nao

private int tam;  // numero de colunas e linhas da board
private float boardSize; // tamanho da board na janela de jogo,
private float padding;  // tamanho do padding em relacao a board
private float slotSize;  // tamanho do slot em relacao a board
private String difficulty; // dificuldade do jogo

private float restartButtonX;
private float restartButtonY;
private float restartButtonWidth;
private float restartButtonHeight;

private float memoryX;
private float memoryY;
private float memoryWidth;
private float memoryHeight;
private float levelWidth;
private float levelHeight;


private Hashtable<String,Integer> aidButtons = new Hashtable<String,Integer>();

private float aidButtonSize;
private boolean doublePiece;


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
  memoryCap = 250;
  levelCap = 100;
  
  memoryWidth = 170;
  memoryHeight = 25;
  levelWidth = memoryWidth;
  levelHeight = 10;
  memoryX = width / 2;
  memoryY = 0.1 * (height - tam) / 2;
  
  aidButtonSize = 35;
  
  aidButtons.put("duplica", 0);
  aidButtons.put("troca", 1);
  aidButtons.put("elimina", 2);
  aidButtons.put("cria", 3);
  
  lost = false;
  doublePiece = false;
}

void draw(){
   background(120);
   drawBoard(campo);
   drawScore();
   drawAidButtons();
   
   
   if(lost == true){
     defeat();
   }
}

void drawAidButtons(){
  fill(120, 40, 150);
  triangle( 0, height, 0, 0, (width - boardSize) *0.45, height);
  
  fill(0, 0, 200);
  ellipse(aidButtonSize , height - (aidButtons.get("duplica") * 1.5 +1) * aidButtonSize, aidButtonSize, aidButtonSize);
  
  ellipse(aidButtonSize , height - (aidButtons.get("troca") * 1.5 +1) * aidButtonSize, aidButtonSize, aidButtonSize);
  
  ellipse(aidButtonSize , height - (aidButtons.get("elimina") * 1.5 +1) * aidButtonSize, aidButtonSize, aidButtonSize);
  
  ellipse(aidButtonSize , height - (aidButtons.get("cria") * 1.5 +1) *aidButtonSize, aidButtonSize, aidButtonSize);
  
  fill(200, 0, 0);
  if(doublePiece){
    ellipse(aidButtonSize , height - (aidButtons.get("duplica") * 1.5 +1) * aidButtonSize, aidButtonSize, aidButtonSize);
    fill(255);
    textSize(18);
    textAlign(CENTER, CENTER);
    text('X', aidButtonSize , height - (aidButtons.get("duplica") * 1.5 +1) * aidButtonSize);
    textAlign(CENTER);
  }
}

void drawScore(){
  pushMatrix();
    
    translate(memoryX - memoryWidth/2, memoryY);
    
    /*
      DRAW PROGRESS BARS
    */
    
    fill(175);
    rect(0, 0, memoryWidth, memoryHeight);
    float colored = score/memoryCap;
    if(colored == 1){
      fill(255, 0, 0);
    }
    else{
      fill(0, 0, 225);
    }
    rect(0, 0, memoryWidth * colored, memoryHeight);
    
    fill(150);
    rect(0, memoryHeight, levelWidth, levelHeight);
    colored = score / levelCap;
    if(colored > 1){
      colored = 1;
    }
    
    fill(200, 130, 0);
    rect(0, memoryHeight, levelWidth * colored, levelHeight);
  
    /*
      DRAW TEXT
    */
    fill(255);
    
    int tempExponent = 0;
    float tempScore = memoryCap;
    while(tempScore / 1024 > 1){
      tempScore = tempScore / 1024;
      tempExponent += 10;
    }
    
    textSize(12);
    String write1 = nf(tempScore,0,2) + ordemToString(tempExponent);
    
    textAlign(RIGHT, BOTTOM);
    text(write1, memoryWidth, memoryHeight);
    
    float split = memoryWidth - textWidth(write1);
    split = split - 0.05 * split;
    
    tempExponent = 0;
    tempScore = score;
    while(tempScore / 1024 > 1){
      tempScore = tempScore / 1024;
      tempExponent += 10;
    }
    
    textAlign(RIGHT, CENTER);
    String write2 = nf(tempScore,0,2) + ordemToString(tempExponent);
    textSize(20);
    text(write2, min(memoryWidth/2 + textWidth(write2)/2,  split), memoryHeight/2);
    textAlign(CENTER);
    
    
    
    /*
      DRAW BUTTONS
    */
    
    
    int border = 2;
    float buttonHeight = memoryHeight + levelHeight;
    
    /* MEMORY INCREASE BUTTON */
    
    translate( 1.05 * memoryWidth, 0);
    
    if(score == memoryCap){
      fill(0, 130, 0);
    }
    else{
      fill(0, 150, 200);
    }
    
    rect(0, 0, buttonHeight, buttonHeight + border);
    
    if(score == memoryCap){
      fill(0, 180, 0);
    }
    else{
      fill(40, 190, 240);
    }
    
    rect(0, 0, buttonHeight, buttonHeight);
    
    
    
    /* LEVEL-UP BUTTON */
    
    translate( -1.1 * memoryWidth - buttonHeight, 0);
    
    if(score >= levelCap){
      fill(0, 130, 0);
    }
    else{
      fill(0, 150, 200);
    }
    
    rect(0, 0, buttonHeight, buttonHeight + border);
    
    if(score >= levelCap){
      fill(0, 180, 0);
    }
    else{
      fill(40, 190, 240);
    }
    
    rect(0, 0, buttonHeight, buttonHeight);
    
    
  popMatrix();
  
}

private String ordemToString(int exponent){
    String ordem = "B";
  
    switch(exponent / 10){
      case 0:
        break;
      case 1:  // 1 KByte
        ordem = "KB";
        break;
      case 2:  // 1 MByte
        ordem = "MB";
        break;
      case 3:  // 1 GByte
        ordem = "GB";
        break;
      case 4:  // 1 TByte
        ordem = "TB";
        break;
      case 5:  // 1 PByte
        ordem = "PB";
        break;
      case 6:  // 1 EByte
        ordem = "EB";
        break;
      case 7:  // 1 ZByte
        ordem = "ZB";
        break;
      case 8:  // 1 YByte
        ordem = "YB";
        break;
      default:
        ordem = "?B";
        break;
    }
    
    return ordem;
  }

void memoryIncrease(){
  memoryCap += score;
  score = 0;
}

void levelIncrease(){
  score -= levelCap;
  levelCap = (3 + 1 * cos(levelCap))  * levelCap;
  campo.levelUp();
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
     textAlign(CENTER);
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
    
    if(score >= memoryCap){
      score = memoryCap;
    }
    campo.randomPiece();
    campo.resetFused();
    
  }
   
   lost = !campo.canMove();
}

void mouseReleased(){
  if(mouseButton == LEFT){
    
    if(lost && mouseX >= restartButtonX && mouseX <= restartButtonX + restartButtonWidth  && mouseY >= restartButtonY && mouseY <= restartButtonY + restartButtonHeight){
      campo = new Board(tam, slotSize, padding, difficulty, color(175), color(200));
      score = 0;
      lost = false;
    }
    else if(!lost){
     if( mouseX >= memoryX + memoryWidth/2 + 0.05 * memoryWidth && mouseX <= memoryX + memoryWidth/2 + 0.05 * memoryWidth + memoryHeight + levelHeight 
       && mouseY >= memoryY && mouseY <= memoryY + memoryHeight + levelHeight){
       
         memoryIncrease();
     }
     
     else if( score >= levelCap && mouseX >= memoryX - memoryWidth/2 - 0.05 * memoryWidth - memoryHeight - levelHeight && mouseX <= memoryX - memoryWidth/2 - 0.05 * memoryWidth
       && mouseY >= memoryY && mouseY <= memoryY + memoryHeight + levelHeight){
         
         levelIncrease();
     }
     else if( pow((mouseX - aidButtonSize), 2) + pow((mouseY - (height - (aidButtons.get("duplica") *1.5 +1) * aidButtonSize) ), 2) <= pow(aidButtonSize/2, 2) ){
       doublePiece = !doublePiece;
     
     }
    }
  }
  
}