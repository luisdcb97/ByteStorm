public class Piece{

  private int number;  // multiples of 2 between 1 and 512 inclusive
  private int exponent; // multiples of 10 
  
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
  
  public boolean equals(Piece peca){
    if(peca == null){
     return false; 
    }
    
    return this.number == peca.getValue() && this.exponent == peca.getExponent();
    
  }
  
}