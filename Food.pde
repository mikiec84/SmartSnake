class Food {
  private Snake snake; // the snake that the food belongs to
  private PVector pos;
  
  Food(Snake snake) {
    this.snake = snake;
    pos = new PVector(floor(random(40)), floor(random(40)));
  }
  
  void show() {
    fill(255, 0, 0); // red
    if (showAll) {
      int xStart = (snake.index() % 10) * 80 + 400;
      int yStart = (snake.index() / 10) * 80;
      rect(pos.x * 2 + xStart, pos.y * 2 + yStart, 2, 2);
    } else
      rect(pos.x * 20 + 400, pos.y * 20, 20, 20);
  }
  
  PVector pos() {
    return pos;
  }
}