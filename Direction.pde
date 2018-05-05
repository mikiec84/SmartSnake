// possible moving directions of the snake
// diagonal moves are not allowed
enum Direction {
  left,
  right,
  up,
  down;
  
  // turn left
  Direction left() {
    if (this == left)
      return down;
    else if (this == right)
      return up;
    else if (this == up)
      return left;
    else
      return right;
  }
  
  // turn right
  Direction right() {
    if (this == left)
      return up;
    else if (this == right)
      return down;
    else if (this == up)
      return right;
    else
      return left;
  }
  
  // velocity of the current direction
  PVector velocity() {
    if (this == left)
      return new PVector(-1, 0);
    else if (this == right)
      return new PVector(1, 0);
    else if (this == up)
      return new PVector(0, -1);
    else
      return new PVector(0, 1);
  }
  
  // direction to degree
  int toDegree() {
    if (this == left)
      return 90;
    else if (this == right)
      return 270;
    else if (this == up)
      return 0;
    else
      return 180;
  }
}