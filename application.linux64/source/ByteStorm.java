import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Hashtable; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ByteStorm extends PApplet {



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


public void setup(){
  noStroke();  
  
  
  tam = 4; // numero de colunas e linhas da board
  
  boardSize = 0.6f * min(width, height); // tamanho da board na janela de jogo,
  padding = 0.15f * boardSize/(tam+1);  // tamanho do padding em relacao a board
  slotSize = 0.85f * boardSize/tam;  // tamanho do slot em relacao a board
  
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
  memoryY = 0.1f * (height - tam) / 2;
  
  aidButtonSize = 35;
  
  aidButtons.put("duplica", 0);
  aidButtons.put("troca", 1);
  aidButtons.put("elimina", 2);
  aidButtons.put("cria", 3);
  
  lost = false;
  doublePiece = false;
}

public void draw(){
   background(120);
   drawBoard(campo);
   drawScore();
   drawAidButtons();
   
   
   if(lost == true){
     defeat();
   }
}

public void drawAidButtons(){
  fill(120, 40, 150);
  triangle( 0, height, 0, 0, (width - boardSize) *0.45f, height);
  
  fill(0, 0, 200);
  ellipse(aidButtonSize , height - (aidButtons.get("duplica") * 1.5f +1) * aidButtonSize, aidButtonSize, aidButtonSize);
  
  ellipse(aidButtonSize , height - (aidButtons.get("troca") * 1.5f +1) * aidButtonSize, aidButtonSize, aidButtonSize);
  
  ellipse(aidButtonSize , height - (aidButtons.get("elimina") * 1.5f +1) * aidButtonSize, aidButtonSize, aidButtonSize);
  
  ellipse(aidButtonSize , height - (aidButtons.get("cria") * 1.5f +1) *aidButtonSize, aidButtonSize, aidButtonSize);
  
  fill(200, 0, 0);
  if(doublePiece){
    ellipse(aidButtonSize , height - (aidButtons.get("duplica") * 1.5f +1) * aidButtonSize, aidButtonSize, aidButtonSize);
    fill(255);
    textSize(18);
    textAlign(CENTER, CENTER);
    text('X', aidButtonSize , height - (aidButtons.get("duplica") * 1.5f +1) * aidButtonSize);
    textAlign(CENTER);
  }
}

public void drawScore(){
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
    split = split - 0.05f * split;
    
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
    
    translate( 1.05f * memoryWidth, 0);
    
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
    
    translate( -1.1f * memoryWidth - buttonHeight, 0);
    
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

public void memoryIncrease(){
  memoryCap += score;
  score = 0;
}

public void levelIncrease(){
  score -= levelCap;
  levelCap = (3 + 1 * cos(levelCap))  * levelCap;
  campo.levelUp();
}

public void defeat(){
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

public void drawBoard(Board tabuleiro){
  float tamanho = (tabuleiro.getTamanho() + 1 ) * tabuleiro.getPadding() + tabuleiro.getTamanho() * tabuleiro.getSlotSize(); // tamanho da board
  
  float boardInitialX = (width - tamanho) / 2; // origem X da board
  float boardInitialY = (height - tamanho) / 2; // origem Y da board
  
  tabuleiro.desenha(boardInitialX, boardInitialY, tamanho);
}

public void keyReleased(){
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

public void mouseReleased(){
  if(mouseButton == LEFT){
    
    if(lost && mouseX >= restartButtonX && mouseX <= restartButtonX + restartButtonWidth  && mouseY >= restartButtonY && mouseY <= restartButtonY + restartButtonHeight){
      campo = new Board(tam, slotSize, padding, difficulty, color(175), color(200));
      score = 0;
      lost = false;
    }
    else if(!lost){
     if( mouseX >= memoryX + memoryWidth/2 + 0.05f * memoryWidth && mouseX <= memoryX + memoryWidth/2 + 0.05f * memoryWidth + memoryHeight + levelHeight 
       && mouseY >= memoryY && mouseY <= memoryY + memoryHeight + levelHeight){
       
         memoryIncrease();
     }
     
     else if( score >= levelCap && mouseX >= memoryX - memoryWidth/2 - 0.05f * memoryWidth - memoryHeight - levelHeight && mouseX <= memoryX - memoryWidth/2 - 0.05f * memoryWidth
       && mouseY >= memoryY && mouseY <= memoryY + memoryHeight + levelHeight){
         
         levelIncrease();
     }
     else if( pow((mouseX - aidButtonSize), 2) + pow((mouseY - (height - (aidButtons.get("duplica") *1.5f +1) * aidButtonSize) ), 2) <= pow(aidButtonSize/2, 2) ){
       doublePiece = !doublePiece;
     
     }
    }
  }
  
}



public class Board{
  
  private final int tamanho;  // linhas e colunas da board (quadrado)
  private final float padding;  // dimens\u00e3o do espa\u00e7o entre cada slot da board
  private final float slotSize;  // dimens\u00e3o de cada slot da board
  private Piece[][] matriz;  // matriz da board
  
  private int baseValue;  // valor base de cada pe\u00e7a
  private int baseExponent;  // expoente base de cada pe\u00e7a
  
  private final int corPadding;  // cor do padding
  private final int corSlotVazio;  // cor dos slots em pe\u00e7as
  
  private final float probDuploValor;  // probabilidade da pe\u00e7a ter valor duplicado em rela\u00e7\u00e3o ao valor base 
  
  public Board( int tam, float slotSize, float pad, String gameMode, int padCol, int slotCol){
    this.tamanho = tam;
    this.padding = pad;
    this.slotSize = slotSize;
    
    this.baseValue = 2;
    this.baseExponent = 0;
    
    switch(gameMode){
      case "VERY EASY":
        this.probDuploValor = 50.0f;
        break;
      case "EASY":
        this.probDuploValor = 25.0f;
        break;
      case "HARD":
        this.probDuploValor = 2.5f;
        break;
      case "VERY HARD":
        this.probDuploValor = 0.5f;
        break;
      case "INSANE":
        this.probDuploValor = 0;
        break;
      default:
        this.probDuploValor = 10.0f;
        break;
    }
  
    this.corPadding = padCol; 
    this.corSlotVazio = slotCol; 
    
    this.matriz = new Piece[tam][tam];
    this.randomStart();
  }
  
  private void randomStart(){
   int numPecas = round(random(2,4)); // numero inteiro entre 2 e 4
   int posX = 0;
   int posY = 0;
   
   // reset da board
   for( int l = 0; l < this.tamanho; l++){
     for( int c = 0; c < this.tamanho; c++){
       matriz[c][l] = null;
     }
   }
   
   // gera <numPecas> pe\u00e7as iniciais
   for( int i = 0; i < numPecas; i++){
     posX = floor( random(0,this.tamanho));
     posY = floor( random(0,this.tamanho));
     
     if(matriz[posX][posY] != null){
      i--;
      continue;
     }
     matriz[posX][posY] = new Piece(this.baseValue, this.baseExponent, this.probDuploValor);
   }
  }
  
  /**
  *  Cria uma nova peca numa posicao aleatoria do tabuleiro
  *
  * @return  true se criou uma nova peca, false se nao conseguiu
  */
  private boolean randomPiece(){
   ArrayList<int[]> livres = new ArrayList<int[]>();
   
   for( int l = 0; l < this.tamanho; l++){
     for( int c = 0; c < this.tamanho; c++){
       if(matriz[c][l] == null){
         int[] posicao = new int[2];
         posicao[0] = c;
         posicao[1] = l;
         livres.add(posicao);
       }
     }
   }
  
   boolean criado = false;
   
   while(livres.size() > 0){
     int pos[] = livres.remove(floor(random(0, livres.size())));
     if(matriz[pos[0]][pos[1]] == null){
       matriz[pos[0]][pos[1]] = new Piece(this.baseValue, this.baseExponent, this.probDuploValor);
       criado = true;
       break;
     }
   }
   
   return criado; // retorna true se uma nova peca foi criada
  }
  
  public void levelUp(){
    for( int l = 0; l < this.tamanho; l++){
     for( int c = 0; c < this.tamanho; c++){
       if(this.matriz[l][c] != null && this.matriz[l][c].getValue() == this.baseValue){
         this.matriz[l][c].doublePiece();
       }
     }
    }
    
    this.baseValue = this.baseValue * 2;
    
    while(this.baseValue >= 1024){
     this.baseValue = this.baseValue / 1024;
     this.baseExponent += 10;
    }
    
  }
  
  public void desenha(float initX, float initY, float size){
    fill(this.corPadding);
    rect(initX, initY, size, size, 10);
    
    
    for( int l = 0; l < this.tamanho; l++){
       for( int c = 0; c < this.tamanho; c++){
         this.desenhaPeca(initX + (c+1) * this.padding + c * this.slotSize, initY + (l+1) * this.padding + l * this.slotSize, this.slotSize, c, l);
       }
     }
    
  }
  
  private void desenhaPeca(float initX, float initY, float size, int col, int lin){
    if(this.matriz[col][lin] == null){
      fill(this.corSlotVazio);
      rect(initX, initY, size, size, 5);
      return;  
    }
    
    fill(this.generateColor(col, lin));
    rect(initX, initY, size, size, 5);
    
    fill(0);  // black for text
    char[] escala = generateOrdem(this.matriz[col][lin].getExponent());
    
    textAlign(CENTER);
    textSize(24);
    text(this.matriz[col][lin].getValue(), initX+ size/2, initY+ size/2);
    textSize(12);
    text(escala, 0, 2, initX + size/2, initY+ size*0.85f);
    
  }
  
  
  private int generateColor(int col, int lin){
    int hue = 0;
    
    colorMode(HSB, 360, 100, 100);
    
    int pieceVal = this.matriz[col][lin].getValue();
    int pieceExp = this.matriz[col][lin].getExponent();
    float multiplier = (log(pieceVal)/log(2) - log(this.baseValue)/log(2) + pieceExp - this.baseExponent);
    int cor;
    
    
    if(multiplier > 9){
       hue = round( 280 - 8 * multiplier );
       cor = color(hue, 100, 70);
    }
    else{
       hue = round( 50 - 5 * multiplier );
       cor = color(hue, 100, 90);
    }
    
    
    
    
    colorMode(RGB, 255, 255, 255);
    
    return cor;
    
  }
  
  private char[] generateOrdem(int exponent){
    char[] ordem = new char[2];
    ordem[1] = 'B';
  
    switch(exponent / 10){
      case 0:  // 1 Byte
        ordem[0] = 'B';
       ordem[1] = ' ';
        break;
      case 1:  // 1 KByte
        ordem[0] = 'K';
        break;
      case 2:  // 1 MByte
        ordem[0] = 'M';
        break;
      case 3:  // 1 GByte
        ordem[0] = 'G';
        break;
      case 4:  // 1 TByte
        ordem[0] = 'T';
        break;
      case 5:  // 1 PByte
        ordem[0] = 'P';
        break;
      case 6:  // 1 EByte
        ordem[0] = 'E';
        break;
      case 7:  // 1 ZByte
        ordem[0] = 'Z';
        break;
      case 8:  // 1 YByte
        ordem[0] = 'Y';
        break;
      default:
        ordem[0] = '?';
        break;
    }
    
    return ordem;
  }
  
  public float moveBoardUP(){
    float points =0;
    for(int c=0; c<this.tamanho; c++){
      for(int l=1; l<this.tamanho; l++){
        if( matriz[c][l] == null){
           continue; 
        }
        for(int moved = 0; l-1-moved >= 0; moved++){
          if( matriz[c][l-moved].equals(matriz[c][l-1-moved])  && !matriz[c][l-moved].getFused() && !matriz[c][l-1-moved].getFused()){
           matriz[c][l-moved] = null;
           points += matriz[c][l-1-moved].doublePiece();
           matriz[c][l-1-moved].setFused(true);
          }
          
          if(matriz[c][l-1-moved] == null ){
              matriz[c][l-1-moved] = matriz[c][l-moved];
              matriz[c][l-moved] = null;
          }
        
        }
      }
    }
    
    return points;
    
  }
  
  public float moveBoardDOWN(){
    float points =0;
    for(int c=0; c<this.tamanho; c++){
      for(int l=tamanho-2; l>=0; l--){
        if( matriz[c][l] == null){
           continue; 
        }
        for(int moved = 0; l+1+moved < this.tamanho; moved++){
          if( matriz[c][l+moved].equals(matriz[c][l+1+moved]) && !matriz[c][l+moved].getFused() && !matriz[c][l+1+moved].getFused()){
           matriz[c][l+moved] = null;
           points += matriz[c][l+1+moved].doublePiece();
           matriz[c][l+1+moved].setFused(true);
          }
          
          if(matriz[c][l+1+moved] == null ){
              matriz[c][l+1+moved] = matriz[c][l+moved];
              matriz[c][l+moved] = null;
          }
        
        }
      }
    }
    
    return points;
    
  }
  
  public float moveBoardLEFT(){
    float points =0;
    for(int c=1; c<this.tamanho; c++){
      for(int l=0; l<this.tamanho; l++){
        if( matriz[c][l] == null){
           continue; 
        }
        for(int moved = 0; c-1-moved >= 0; moved++){
          if( matriz[c-moved][l].equals(matriz[c-1-moved][l]) && !matriz[c-moved][l].getFused() && !matriz[c-1-moved][l].getFused()){
           matriz[c-moved][l] = null;
           points += matriz[c-1-moved][l].doublePiece();
           matriz[c-1-moved][l].setFused(true);
          }
          
          if(matriz[c-1-moved][l] == null ){
              matriz[c-1-moved][l] = matriz[c-moved][l];
              matriz[c-moved][l] = null;
          }
        
        }
      }
    }
    
    return points;
    
  }
  
  public float moveBoardRIGHT(){
    float points =0;
    for(int c=tamanho-2; c>=0; c--){
      for(int l=0; l<tamanho; l++){
        if( matriz[c][l] == null){
           continue; 
        }
        for(int moved = 0; c+1+moved < this.tamanho; moved++){
          if( matriz[c+moved][l].equals(matriz[c+1+moved][l]) && !matriz[c+moved][l].getFused() && !matriz[c+1+moved][l].getFused()){
           matriz[c+moved][l] = null;
           points += matriz[c+1+moved][l].doublePiece();
           matriz[c+1+moved][l].setFused(true);
          }
          
          if(matriz[c+1+moved][l] == null ){
              matriz[c+1+moved][l] = matriz[c+moved][l];
              matriz[c+moved][l] = null;
          }
        
        }
      }
    }
    
    return points;
    
  }
  
  public void resetFused(){
    for(int c=0; c<this.tamanho; c++){
      for(int l=0; l<this.tamanho; l++){
        if( matriz[c][l] != null){
          matriz[c][l].setFused(false);
        }  
      }
    }
  }
  
  public boolean canMove(){
    boolean moveable = false;
    
    for(int c=0; c<this.tamanho; c++){
      for(int l=0; l<this.tamanho; l++){
        
        if(this.matriz[c][l] == null
        || (c-1 > 0 && this.matriz[c][l].equals(this.matriz[c-1][l]))
        || (c+1 < this.tamanho && this.matriz[c][l].equals(this.matriz[c+1][l]))
        || (l-1 > 0 && this.matriz[c][l].equals(this.matriz[c][l-1]))
        || (l+1 < this.tamanho && this.matriz[c][l].equals(this.matriz[c][l+1]))
        ){
          moveable = true;
          break;
        }
        
      }
      
      if(moveable == true){
        break;
      }
    }
    
    return moveable;
  }
  
  public boolean canMove(int direction){
    boolean moveable = false;
    
    for(int c=0; c<this.tamanho; c++){
      for(int l=0; l<this.tamanho; l++){
        
        if( matriz[c][l] == null){
         continue; 
        }
        
        if( ( direction == LEFT && (c-1 >= 0 && (matriz[c-1][l] == null || this.matriz[c][l].equals(this.matriz[c-1][l]) ) ) )
           || ( direction == RIGHT && (c+1 < this.tamanho && (matriz[c+1][l] == null || this.matriz[c][l].equals(this.matriz[c+1][l]) ) ) ) 
           || ( direction == UP  && (l-1 >= 0 && (matriz[c][l-1] == null || this.matriz[c][l].equals(this.matriz[c][l-1]) ) ) ) 
           || ( direction == DOWN && (l+1 < this.tamanho && (matriz[c][l+1] == null || this.matriz[c][l].equals(this.matriz[c][l+1]) ) ) ) 
        ){
          moveable = true;
          break;
        }
        
        
        
      }
      if(moveable == true){
        break;
      }
    }
    
    return moveable;
  }
  
  
  
  public int getTamanho(){
    return this.tamanho;
  }
  
  public Piece getPiece(int lin, int col){
    return this.matriz[lin][col];
  }
  
  public float getPadding(){
    return this.padding;
  }
  
  public float getSlotSize(){
    return this.slotSize;
  }
  
  public int getPaddingColor(){
    return this.corPadding;
  }
  
  public int getSlotColor(){
    return this.corSlotVazio;
  }
  
  public int getBaseValue(){
    return this.baseValue;
  }
  
  public int getBaseExponent(){
    return this.baseExponent;
  }
  
  public void newPiece(int lin, int col){
    this.matriz[col][lin] = new Piece(this.baseValue, this.baseExponent, this.probDuploValor);
  }
  
  
}
public class Piece{

  private int number;  // multiples of 2 between 1 and 512 inclusive
  private int exponent; // multiples of 10 
  private boolean fused; // if the piece has been fused before
  
  public Piece(int baseVal, int baseExp, float prob){
    this.generateNumber(baseVal,baseExp, prob);
    
  }
  
  
  /**
  * Gera o valor e expoente para a peca
  *
  * @param  Valor base do tabuleiro
  * @param  Expoente base do tabuleiro
  * @param  Probabilidade de uma peca ter valor duplo no tabuleiro
  */
  private void generateNumber(int baseVal, int baseExp, float probAumento){
    number = baseVal;
    exponent = baseExp;
    
    if(random(0, 100) < probAumento){
      number = number * 2;
      while( number >= 1024){
        number = number/1024;
        exponent += 10;
      }
    }
  }

  public float doublePiece(){
    number = number * 2;
    while( number >= 1024){
      number = number/1024;
      exponent += 10;
    }
    return number* pow(2, exponent);
  }

  public int getValue(){
   return this.number; 
  }
  
  
  public int getExponent(){
   return this.exponent; 
  }
  
  public boolean getFused(){
   return this.fused; 
  }
  
  public void setFused(boolean set){
   this.fused = set; 
  }
  
  public boolean equals(Piece peca){
    if(peca == null){
     return false; 
    }
    
    return this.number == peca.getValue() && this.exponent == peca.getExponent();
    
  }
  
}
  public void settings() {  size(640, 480); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ByteStorm" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
