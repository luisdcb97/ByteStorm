public static class GameSettings{

  public static String DIFFICULTY = "NORMAL";
  public static int SLOTS = 4;
  public static int BOARD_QTY = 1;
  public static int INITIAL_LEVEL = 1;
  public static float INITIAL_MEMORY_CAP = 250f;
  public static float INITIAL_LEVEL_CAP = 100f;
  
  
  
  
  public static float decodeDifficulty(String diff){
    float multiplier;
    
    switch(diff){
        case "VERY EASY":
          multiplier = 0.65;
          break;
        case "EASY":
          multiplier = 0.85;
          break;
        case "HARD":
          multiplier = 1.25;
          break;
        case "VERY HARD":
          multiplier = 1.5;
          break;
        case "INSANE":
          multiplier = 2;
          break;
        default:
          multiplier = 1;
          break;
      }
    
    return multiplier;
  }
}