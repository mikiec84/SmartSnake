 class Snake {
  private int index; // an index for the snake, 0 <= snake < 100, used for showing the snakes
  private Direction direction;
  private int score; // current score
  private ArrayList<PVector> positions; // positions of the snake
  private boolean alive; // whether the snake is alive
  private Food food; // food that the snake is trying to eat
  private NeuralNetwork brain; // brain that is controlling the snake
  private double lastDistance; // last distance with the food, used to check if the snake is moving
                               // away from the food
  
  Snake(int index) {
    this.index = index;
    this.positions = new ArrayList<PVector>();
    this.positions.add(new PVector(floor(random(40)), floor(random(40)))); // start position of the snake
    alive = true;
    score = 0;
    brain = new NeuralNetwork(6, 6, 3);
    generateNewFood();
    PVector head = positions.get(0);
    PVector foodPos = food.pos();
    // update distance with the food
    lastDistance = Math.sqrt(Math.pow(head.x - foodPos.x, 2) + Math.pow(head.y - foodPos.y, 2));
    
    float random = random(4);
    if (random < 1)
      direction = Direction.up;
    else if (random < 2)
      direction = Direction.left;
    else if (random < 3)
      direction = Direction.down;
    else
      direction = Direction.right;
  }
  
  // show the snake on the board
  void show() {
    fill(255);
    if (showAll) {
      int xStart = (index % 10) * 80 + 400;
      int yStart = (index / 10) * 80;
      for (int i = 1; i < positions.size(); ++i)
        rect(positions.get(i).x * 2 + xStart, positions.get(i).y * 2 + yStart, 2, 2);
      fill(0, 255, 0);
      rect(positions.get(0).x * 2 + xStart, positions.get(0).y * 2 + yStart, 2, 2);
    } else {
      for (int i = 0; i < positions.size(); ++i) {
        if (i < 50)
          fill(255 - i * 5);
        else
          fill(0);
        rect(positions.get(i).x * 20 + 400, positions.get(i).y * 20, 20, 20);
      }
      fill(0, 255, 0);
      rect(positions.get(0).x * 20 + 400, positions.get(0).y * 20, 20, 20);
    }
    food.show();
  }
  
  // generate new food for the snake, the new food should not be one the body of the snake
  void generateNewFood() {
    do {
      food = new Food(this);
    } while (contains(food.pos()));
  }
  
  // check whether the body of the snake contains the given position
  boolean contains(PVector pos) {
    PVector temp;
    for (int i = 0; i < positions.size(); ++i) {
      temp = positions.get(i);
      if (temp.x == pos.x && temp.y == pos.y)
        return true;
    }
    return false;
  }
  
  // getter for alive
  boolean isAlive() {
    return alive;
  }
  
  // getter for score
  int score() {
    return score;
  }
  
  // getter for index
  int index() {
    return index;
  }
  
  // setter for index
  void setIndex(int newIndex) {
    this.index = newIndex;
  }
  
  // check if new head position will hit the wall
  boolean willHitWall(PVector pos) {
    return pos.x < 0 || pos.x >= 40 ||
           pos.y < 0 || pos.y >= 40;
  }
  
  // check if new head position will case the snake to die
  boolean willDie(PVector pos) {
    if (willHitWall(pos))
      return true;
    
    // the snake head can move to the position of the last tail since the position of the last
    // tail will be updated
    PVector temp;
    for (int i = 0; i < positions.size() - 1; ++i) {
      temp = positions.get(i);
      if (temp.x == pos.x && temp.y == pos.y)
        return true;
    }
    return false;
  }
  
  // check if new head position will let the snake eat the food
  boolean willEatFood(PVector pos) {
    PVector foodPos = food.pos(); // position of the food
    return pos.x == foodPos.x && pos.y == foodPos.y;
  }  
  
  // update the position of the snake based on the direction the snake is moving
  void updatePos() {
    if (!alive) // cannot update position after the snake has died
      return;
      
    decideNextMove(); // decide next move based on current status
    PVector velocity = direction.velocity();
    PVector head = new PVector(positions.get(0).x, positions.get(0).y);
    head.add(velocity); // move the head
    if (willDie(head)) {
      alive = false;
      return;
    } else if (willEatFood(head)) {
      positions.add(0, head);
      generateNewFood();
      score += 10; // reward the snake as it has eaton a food!
      PVector foodPos = food.pos();
      // update distance with the food
      lastDistance = Math.sqrt(Math.pow(head.x - foodPos.x, 2) + Math.pow(head.y - foodPos.y, 2));
    } else { //update tail positions
      for (int i = positions.size() - 1; i > 0 ; --i)
        positions.set(i, positions.get(i - 1));
      positions.set(0, head);
      
      PVector foodPos = food.pos();
      // new distance with the food
      double newDistance = Math.sqrt(Math.pow(head.x - foodPos.x, 2) + Math.pow(head.y - foodPos.y, 2));
      if (newDistance > lastDistance)
        score -= 2; // decrease the score by 2 as the snake is not trying to eat the food :(
      else
        score += 1; // increase the score by 1 as the snake is moving toward the food :)
      
      if (score <= -50) // the snake has negative score :(
        alive = false;
      lastDistance = newDistance;
    }
  }
  
  // create input to neural network
  float[] look() {
    float[] result = new float[6];
    Direction[] directionList = {this.direction.left(), this.direction, this.direction.right()};
    PVector head = positions.get(0);
    
    int currentIndex = 0;
    for (Direction dir : directionList) {
      PVector vel = dir.velocity();
      if (!willDie(new PVector(head.x + vel.x, head.y + vel.y))) // looks like it's clear in the direction
        result[currentIndex++] = 1;
      else
        ++currentIndex;
    }
    
    // find the direction of the food
    PVector foodPos = food.pos();
    double theta = Math.atan2(foodPos.y - head.y, foodPos.x - head.x);
    theta += Math.PI / 2.0; // rotate the angle clockwise
    double angle = Math.toDegrees(theta);
    angle += direction.toDegree();
    if (angle > 180) // keep angle between [-180, 180]
      angle -= 360;
 
    if (angle <= -45)
      result[3] = 1;
    else if (angle < 45)
      result[4] = 1;
    else
      result[5] = 1;
    
    return result;
  }

  // decide next move using neural network
  void decideNextMove() {
    float[] input = look(); // create input to the neural network
    float[] output = brain.output(input); // create output using neural network
    
    float max = max(output); // find the maximum of the output array
    if (max == output[0])
      direction = direction.left(); // turn left
    else if (max == output[1])
      return; // keep current direction
    else if (max == output[2])
      direction = direction.right(); // turn right
  }
  
  // creata a new snake who has the brain from the given snake
  Snake clone() {
    Snake s = new Snake(index);
    s.brain = brain.clone();
    return s;
  }
  
  // create a new snake by crossover two snakes
  Snake crossover(Snake other, int index) {
    Snake s = new Snake(index);
    s.brain = brain.crossover(other.brain);
    return s;
  }
  
  void mutate() {
    brain.mutate(globalMutationRate);
  }
}