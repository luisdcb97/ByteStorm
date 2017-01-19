public class Board{
  
  private final int tamanho;  // linhas e colunas da board (quadrado)
  private final float padding;  // dimensão do espaço entre cada slot da board
  private final float slotSize;  // dimensão de cada slot da board
  private Piece[][] matriz;  // matriz da board
  
  private int baseValue;  // valor base de cada peça
  private int baseExponent;  // expoente base de cada peça
  
  private final color corPadding;  // cor do padding
  private final color corSlotVazio;  // cor dos slots em peças
  
  private final float probDuploValor;  // probabilidade da peça ter valor duplicado em relação ao valor base 
  
  public Board( int tam, float slotSize, float pad, String gameMode, color padCol, color slotCol){
    this.tamanho = tam;
    this.padding = pad;
    this.slotSize = slotSize;
    
    this.baseValue = 2;
    this.baseExponent = 0;
    
    switch(gameMode){
      case "Very Easy":
        this.probDuploValor = 50.0;
        break;
      case "Easy":
        this.probDuploValor = 25.0;
        break;
      case "Hard":
        this.probDuploValor = 2.5;
        break;
      case "Very Hard":
        this.probDuploValor = 0.5;
        break;
      default:
        this.probDuploValor = 10.0;
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
   
   // gera <numPecas> peças iniciais
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
    text(escala, 0, 2, initX+ size/2, initY+ size*0.85);
    
  }
  
  
  private color generateColor(int col, int lin){
    int red = 0;
    int green = 0;
    int blue = 0;
    
    int pieceVal = this.matriz[col][lin].getValue();
    int pieceExp = this.matriz[col][lin].getExponent();
    
    if( pieceExp >= baseExponent + 10){
      red = max(40, 80 - floor(10 * log(pieceVal)/log(2)) );
      blue = max(55, 100 - floor(10 * log(pieceVal)/log(2)) );
      // lower values have lighter purple tones
    }
    else{
      red = max(170, 255 - floor(10 * log(pieceVal)/log(2)) );
      green = max(90, 190 - floor(20 * log(pieceVal)/log(2)) );
      // lower values have lighter orange-yellow tones
    }
    
    
    return color(red, green, blue);
    
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
        
        if( ( direction == LEFT && (c-1 > 0 && (matriz[c-1][l] == null || this.matriz[c][l].equals(this.matriz[c-1][l]) ) ) )
           || ( direction == RIGHT && (c+1 < this.tamanho && (matriz[c+1][l] == null || this.matriz[c][l].equals(this.matriz[c+1][l]) ) ) ) 
           || ( direction == DOWN  && (l-1 > 0 && (matriz[c][l-1] == null || this.matriz[c][l].equals(this.matriz[c][l-1]) ) ) ) 
           || ( direction == UP && (l+1 < this.tamanho && (matriz[c][l+1] == null || this.matriz[c][l].equals(this.matriz[c][l+1]) ) ) ) 
        ){
          moveable = true;
          break;
        }
        
        /*if( ( (direction == LEFT || direction == RIGHT) && ( (c-1 > 0 && (matriz[c-1][l] == null || this.matriz[c][l].equals(this.matriz[c-1][l]) )  )
            || (c+1 < this.tamanho && (matriz[c+1][l] == null || this.matriz[c][l].equals(this.matriz[c+1][l]) ) ) ) ) 
        || ( (direction == DOWN || direction == UP) && ( (l-1 > 0 && (matriz[c][l-1] == null || this.matriz[c][l].equals(this.matriz[c][l-1]) ) ) 
            || (l+1 < this.tamanho && (matriz[c][l+1] == null || this.matriz[c][l].equals(this.matriz[c][l+1]) ) ) ) )
        ){
          moveable = true;
          break;
        }*/
        
        
      }
      if(moveable == true){
        break;
      }
    }
    if(!moveable) println("FALSE");
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
  
  public color getPaddingColor(){
    return this.corPadding;
  }
  
  public color getSlotColor(){
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