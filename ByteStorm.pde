import java.util.Hashtable;
import java.io.*;

private Board[] campo;  // tabuleiro de jogo
private float score;  // pontuacao
private float memoryCap;  // maximo score possivel
private float levelCap; // score necessario para subir de nivel
private int level; // nivel atual
private float difficultyMultiplier;


private boolean lost;  // se o jogador perdeu ou nao

private float boardSize; // tamanho da board na janela de jogo
private float boardPadding;
private float padding;  // tamanho do padding em relacao a board
private float slotSize;  // tamanho do slot em relacao a board

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

private float saveX;
private float saveY;
private float saveWidth;
private float saveHeight;

private Hashtable<String, Integer> aidButtons = new Hashtable<String, Integer>();

private float aidButtonSize;
private boolean doublePiece;


void setup() {  
  //fullScreen();
  size(640, 480);
  noStroke();
  noLoop();
  
  boolean read = readFile(GameSettings.FOLDERNAME + File.separator + GameSettings.FILENAME);
  
  difficultyMultiplier = GameSettings.decodeDifficulty(GameSettings.DIFFICULTY);
    
  if(!read){
    memoryCap = GameSettings.INITIAL_MEMORY_CAP * (1/difficultyMultiplier);
    levelCap = GameSettings.INITIAL_LEVEL_CAP * difficultyMultiplier;
    score = 0;
    level = GameSettings.INITIAL_LEVEL;
  }

  boardSize = 0.6 * min(width, height) / GameSettings.BOARD_QTY; // tamanho da board na janela de jogo
  boardPadding = 0.2 * boardSize;
  padding = 0.15 * boardSize/(GameSettings.SLOTS+1);  // tamanho do padding em relacao a board
  slotSize = 0.85 * boardSize/GameSettings.SLOTS;  // tamanho do slot em relacao a board

  campo = new Board[GameSettings.BOARD_QTY];

  for (int i = 0; i < campo.length; i++) {
    campo[i] = new Board(GameSettings.SLOTS, slotSize, padding, GameSettings.DIFFICULTY, color(175), color(200));
  }

  memoryWidth = (boardSize * GameSettings.BOARD_QTY) / (1 +  0.15+ 1/4.0 * 0.15 +  2 * 0.05 );
  memoryHeight = 0.15 * memoryWidth;
  levelWidth = memoryWidth;
  levelHeight = 1/4.0 * memoryHeight;
  memoryX = width / 2;
  memoryY = 0.1 * (height - GameSettings.SLOTS) / 2;

  aidButtonSize = 35;

  aidButtons.put("duplica", 0);
  aidButtons.put("troca", 1);
  aidButtons.put("elimina", 2);
  aidButtons.put("cria", 3);

  saveX=25;
  saveY=25;
  saveHeight=50;
  saveWidth=100;

  if(read){
    startAtLevel(level);
  }

  lost = false;
  doublePiece = false;
}

void draw() {
  background(120);
  
  drawBoard(campo);
  
  drawScore();
  drawSaveButton();
  drawAidButtons();

  if (lost == true) {
    defeat();
  }


  if (!focused) {
    fill(25, 25, 25, 150);
    rect(0, 0, width, height);
  }
}

public boolean readFile(String name){
  File fich = new File(sketchPath() + name);
  if(!fich.exists() || !fich.isFile()){
    // file does not exist or is a directory
    return false;
  }
  
  String lines[] = loadStrings(sketchPath() + name);
  
  if(lines.length != 7){
    System.out.println("Wrong number of lines in savefile");
    return false;
  }
  for(int i = 0; i < lines.length; i++){
    if(!lines[i].contains("=")){
      System.out.println("Missing attribuition on line " + i);
      System.out.println("Correct Form:\n\tATTRIBUTE=VALUE");
      return false;
    }
  }
  
  GameSettings.DIFFICULTY = lines[0].substring(lines[0].indexOf("=") + "=".length(),lines[0].length());
  GameSettings.SLOTS = Integer.valueOf(lines[1].substring(lines[1].indexOf("=") + "=".length(),lines[1].length()));
  GameSettings.BOARD_QTY = Integer.valueOf(lines[2].substring(lines[2].indexOf("=") + "=".length(),lines[2].length()));
  level = Integer.valueOf(lines[3].substring(lines[3].indexOf("=") + "=".length(),lines[3].length()));
  levelCap = Float.valueOf(lines[4].substring(lines[4].indexOf("=") + "=".length(),lines[4].length()));
  memoryCap = Float.valueOf(lines[5].substring(lines[5].indexOf("=") + "=".length(),lines[5].length()));
  score = Float.valueOf(lines[6].substring(lines[6].indexOf("=") + "=".length(),lines[6].length()));
  
  /*System.out.println(GameSettings.DIFFICULTY);
  System.out.println(GameSettings.SLOTS);
  System.out.println(GameSettings.BOARD_QTY);
  System.out.println(level);
  System.out.println(levelCap);
  System.out.println(memoryCap);
  System.out.println(score);*/
  
  return true;
}

public void writeFile(String name){
    String lines[] = new String[7];
    
    lines[0] = "DIFFICULTY=" + GameSettings.DIFFICULTY;
    lines[1] = "SLOTS=" + GameSettings.SLOTS;
    lines[2] = "BOARDS=" + GameSettings.BOARD_QTY;
    lines[3] = "LEVEL=" + level;
    lines[4] = "INI_LEV_CAP=" + levelCap;
    lines[5] = "INI_MEM_CAP=" + memoryCap;
    lines[6] = "CUR_SCORE=" + score;
    
    
    saveStrings(sketchPath() + name, lines);
    System.out.println("saved");
  
}

void drawSaveButton(){
  fill(0);
  rect(25, 25, 100, 50);
}

void drawAidButtons() {
  fill(120, 40, 150);
  triangle( 0, height, 0, 0, (width - boardSize) *0.45, height);

  fill(0, 0, 200);
  ellipse(aidButtonSize, height - (aidButtons.get("duplica") * 1.5 +1) * aidButtonSize, aidButtonSize, aidButtonSize);

  ellipse(aidButtonSize, height - (aidButtons.get("troca") * 1.5 +1) * aidButtonSize, aidButtonSize, aidButtonSize);

  ellipse(aidButtonSize, height - (aidButtons.get("elimina") * 1.5 +1) * aidButtonSize, aidButtonSize, aidButtonSize);

  ellipse(aidButtonSize, height - (aidButtons.get("cria") * 1.5 +1) *aidButtonSize, aidButtonSize, aidButtonSize);

  fill(200, 0, 0);
  if (doublePiece) {
    ellipse(aidButtonSize, height - (aidButtons.get("duplica") * 1.5 +1) * aidButtonSize, aidButtonSize, aidButtonSize);
    fill(255);
    textSize(18);
    textAlign(CENTER, CENTER);
    text('X', aidButtonSize, height - (aidButtons.get("duplica") * 1.5 +1) * aidButtonSize);
    textAlign(CENTER);
  }
}

void drawScore() {
  pushMatrix();

  translate(memoryX - memoryWidth/2, memoryY);

  /*
      DRAW PROGRESS BARS
   */

  fill(175);
  rect(0, 0, memoryWidth, memoryHeight);
  float colored = score/memoryCap;
  if (colored == 1) {
    fill(255, 0, 0);
  } else {
    fill(0, 0, 225);
  }
  rect(0, 0, memoryWidth * colored, memoryHeight);

  fill(150);
  rect(0, memoryHeight, levelWidth, levelHeight);
  colored = score / levelCap;
  if (colored > 1) {
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
  while (tempScore / 1024 > 1) {
    tempScore = tempScore / 1024;
    tempExponent += 10;
  }

  //textSize(12);
  textSize(0.4 * memoryHeight);
  String write1 = nf(tempScore, 0, 2) + ordemToString(tempExponent);

  textAlign(RIGHT, BOTTOM);
  text(write1, memoryWidth, memoryHeight);

  float split = memoryWidth - textWidth(write1);
  split = split - 0.05 * split;

  tempExponent = 0;
  tempScore = score;
  while (tempScore / 1024 > 1) {
    tempScore = tempScore / 1024;
    tempExponent += 10;
  }

  textAlign(RIGHT, CENTER);
  String write2 = nf(tempScore, 0, 2) + ordemToString(tempExponent);
  textSize(0.6 * memoryHeight);
  text(write2, min(memoryWidth/2 + textWidth(write2)/2, split), memoryHeight/2);
  textAlign(CENTER);



  /*
      DRAW BUTTONS
   */


  float buttonHeight = memoryHeight + levelHeight;
  int border = round(0.05 * buttonHeight);

  /* MEMORY INCREASE BUTTON */

  translate( 1.05 * memoryWidth, 0);

  if (score == memoryCap) {
    fill(0, 130, 0);
  } else {
    fill(0, 150, 200);
  }

  rect(0, 0, buttonHeight, buttonHeight + border);

  if (score == memoryCap) {
    fill(0, 180, 0);
  } else {
    fill(40, 190, 240);
  }

  rect(0, 0, buttonHeight, buttonHeight);



  /* LEVEL-UP BUTTON */

  translate( -1.1 * memoryWidth - buttonHeight, 0);

  if (score >= levelCap) {
    fill(0, 130, 0);
  } else {
    fill(0, 150, 200);
  }

  rect(0, 0, buttonHeight, buttonHeight + border);

  if (score >= levelCap) {
    fill(0, 180, 0);
  } else {
    fill(40, 190, 240);
  }

  rect(0, 0, buttonHeight, buttonHeight);

  textSize(0.5 * buttonHeight);
  fill(255);
  text(level, buttonHeight/2, buttonHeight *2/3);

  popMatrix();
}

private String ordemToString(int exponent) {
  String ordem = "B";

  switch(exponent / 10) {
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

void memoryIncrease() {
  memoryCap += score;
  score = 0;
}

void levelIncrease() {
  score -= levelCap;
  level++;
  levelCap += pow(level, 0.5) * difficultyMultiplier * levelCap;
  for (int i = 0; i< campo.length; i++) {
    campo[i].levelUp();
  }
}

void defeat() {
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

void drawBoard(Board[] tabuleiro) { 
  
  pushMatrix();
  translate(width/2 - (GameSettings.BOARD_QTY * boardSize/2) - boardPadding/2 *(GameSettings.BOARD_QTY-1),(height-boardSize)/2);
  for ( int i =0; i< campo.length; i++) {
    tabuleiro[i].desenha(0, 0, boardSize);
    translate(boardSize + boardPadding, 0);
  }
  popMatrix();
}

void startAtLevel(int nivel){
  for(int i = GameSettings.INITIAL_LEVEL; i < nivel; i++){
    for (int j = 0; j< campo.length; j++) {
      campo[j].levelUp();
    }
  }
}

void keyReleased() {
  redraw();
  if (lost) {
    return;
  } else {
    for (int i = 0; i< campo.length; i++) {
      if ( (keyCode == DOWN || keyCode == UP || keyCode == RIGHT || keyCode == LEFT) && campo[i].canMove(keyCode)) { 
        switch(keyCode) {
        case UP:
          score += campo[i].moveBoardUP() * (1/difficultyMultiplier);
          break;
        case DOWN:
          score += campo[i].moveBoardDOWN() * (1/difficultyMultiplier);
          break;
        case LEFT:
          score += campo[i].moveBoardLEFT() * (1/difficultyMultiplier);
          break;
        case RIGHT:
          score += campo[i].moveBoardRIGHT() * (1/difficultyMultiplier);
          break;
        default:
        }

        if (score >= memoryCap) {
          score = memoryCap;
        }
        campo[i].randomPiece();
        campo[i].resetFused();
      }
    }
  }
  
  lost = false;
  for (int i = 0; i< campo.length; i++) {
    if(!campo[i].canMove() ){
      lost = true;
      break;
    }
  }
}

void mouseReleased() {
  redraw();
  if (mouseButton == LEFT) {

    if (lost && mouseX >= restartButtonX && mouseX <= restartButtonX + restartButtonWidth  && mouseY >= restartButtonY && mouseY <= restartButtonY + restartButtonHeight) {
      for (int i = 0; i< campo.length; i++) {
        campo[i] = new Board(GameSettings.SLOTS, slotSize, padding, GameSettings.DIFFICULTY, color(175), color(200));
      }
      score = 0;
      lost = false;
    } else if (!lost) {
      if ( mouseX >= memoryX + memoryWidth/2 + 0.05 * memoryWidth && mouseX <= memoryX + memoryWidth/2 + 0.05 * memoryWidth + memoryHeight + levelHeight 
        && mouseY >= memoryY && mouseY <= memoryY + memoryHeight + levelHeight) {

        memoryIncrease();
      } else if ( score >= levelCap && mouseX >= memoryX - memoryWidth/2 - 0.05 * memoryWidth - memoryHeight - levelHeight && mouseX <= memoryX - memoryWidth/2 - 0.05 * memoryWidth
        && mouseY >= memoryY && mouseY <= memoryY + memoryHeight + levelHeight) {

        levelIncrease();
      } else if ( pow((mouseX - aidButtonSize), 2) + pow((mouseY - (height - (aidButtons.get("duplica") *1.5 +1) * aidButtonSize) ), 2) <= pow(aidButtonSize/2, 2) ) {
        doublePiece = !doublePiece;
      } else if(mouseX >= saveX && mouseX <= saveX + saveWidth && mouseY >= saveY && mouseY <= saveY + saveHeight){
          writeFile(GameSettings.FOLDERNAME + "/" + GameSettings.FILENAME);
      } 
    } 
    
    
  }
}