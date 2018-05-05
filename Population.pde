class Population {
  private Snake[] population;
  private int generations; // generations count
  private int bestSnake; // index of the best snake
  private int bestScore; // current best score
  private int globalBest; // global best score
  
  Population() {
    population = new Snake[100]; // create a population with 100 snakes
    for (int i = 0; i < 100; ++i)
      population[i] = new Snake(i);
    generations = 1;
    bestSnake = 0; // initially set the best snake to be the first snake
    bestScore = 0; // set initial best score to -1
    globalBest = 0;
  }
  
  void show() {
    if (showAll) { // show all the snakes
      // draw lines to split the snakes
      for (int i = 1; i < 10; ++i) {
        line(400, i * 80, 1200, i * 80);
        line(400 + i * 80, 0, 400 + i * 80, 800);
      }
      for (Snake s : population)
        s.show();
    } else { // only show the current best snake
      population[bestSnake].show();
      showScore(bestSnake);
    }
  }
  
  void showSpecific(int index) {
    population[index].show();
    showScore(index);
  }
  
  void showScore(int index) {
    fill(0);
    textSize(25);
    text("current score: " + population[index].score(), 10, 250);
  }
  
  // getter for generations
  int generations() {
    return generations;
  }
  
  // getter for globalBest
  int globalBest() {
    return globalBest;
  }
  
  // return whether all snakes in current population has all died
  boolean finished() {
    for (Snake s : population) {
      if (s.isAlive())
        return false;
    }
    return true;
  }
  
  // update current population, either move all the alive snakes,
  // or evolve if all snakes have died
  void update() {
    if (!finished()) { // if at least one snake is alive
      for (Snake s : population)
        s.updatePos();
      updateCurrentBest();
    } else { // all snakes have died, should create a new population
      resetCurrentBest();
      evolve();
    }
  }
  
  // update current best snakes
  void updateCurrentBest() {
    int maxScore = population[0].score();
    int maxIndex = 0;
    for (int i = 1; i < population.length; ++i) {
      if (population[i].isAlive() && population[i].score() >= maxScore) {
        maxScore = population[i].score();
        maxIndex = i;
      }
    }
    // if previous best snake dies, then we change the best snake that is showing
    if (!population[bestSnake].isAlive())
      bestSnake = maxIndex;
    
    if (maxScore > bestScore + 5) {
      bestScore = maxScore;
      bestSnake = maxIndex;
    }
    
    if (maxScore > globalBest)
      globalBest = bestScore;
  }
  
  // reset current best snake as the population has evolved
  void resetCurrentBest() {
    bestScore = -1;
    bestSnake = 0;
  }
  
  int findkthBestSnake(int k, int[] snakeIndexes) {
    int pivot = floor(random(snakeIndexes.length));
    int score = population[snakeIndexes[pivot]].score();
    
    IntList smallIndexes = new IntList();
    IntList largerIndexes = new IntList();
    IntList equalIndexes = new IntList();
    for (int index : snakeIndexes) {
      int currentScore = population[index].score();
      if (currentScore > score)
        smallIndexes.append(index);
      else if (currentScore < score)
        largerIndexes.append(index);
      else
        equalIndexes.append(index);
    }
    if (k <= smallIndexes.size()) {
      return findkthBestSnake(k, smallIndexes.array());
    } else if (k <= smallIndexes.size() + equalIndexes.size())
      return score;
    else
      return findkthBestSnake(k - smallIndexes.size() - equalIndexes.size(), largerIndexes.array());
  }
  
  // save all the scores
  void saveScore() {
    t.addColumn("Generation #" + generations);
    int totalScore = 0;
    for (int i = 0; i < 100; ++i) {
      TableRow tr = t.getRow(i);
      totalScore += population[i].score();
      tr.setInt(generations, population[i].score());
    }
    TableRow tr = t.getRow(100);
    tr.setFloat(generations, totalScore / 100.0);
  }
  
  void evolve() {
    saveScore();
    int[] index = new int[100];
    for (int i = 0; i < 100; ++i)
      index[i] = i;
    int score = findkthBestSnake(10, index); // find 10 best snake to create next population
    
    int totalScore = 0;
    ArrayList<Snake> matingpool = new ArrayList<Snake>();
    for (Snake s : population) {
      totalScore += s.score();
      if (s.score() >= score) {
        matingpool.add(s.clone());
        //print("One of the snake has index " + s.index() + " score is " + s.score() + "\n");
      }
    }
    
    print("Generation #" + generations + ": average score is " + totalScore / 100.0 + "\n");
    
    Snake[] newSnakes = new Snake[100];
    
    for (int i = 0; i < 100; ++i) {
      Snake p1 = matingpool.get(floor(random(matingpool.size())));
      Snake p2 = matingpool.get(floor(random(matingpool.size())));
      
      newSnakes[i] = p1.crossover(p2, i);
      newSnakes[i].mutate();
    }
    population = newSnakes;
    generations += 1; // increase generation count
  }
}