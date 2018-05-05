# SmartSnake

This project intends to evolve neural network using genetic algorithm to play the snake game.  

The project used two important AI techniques:  
  - neural network  
  - genetic algorithm  

Initially the parameters in the neural network are all randomly generated, and 100 snakes are generated to serve as the initial population. As it can be shown from the screenshot, after certain generations, the snakes become 'smarter'.  

Screenshot after the game has ran for a while:  
![ScreenShot](/screenshot/snake.png?raw=true "snake")  

Problem for this project:  
  - the snakes are getting smarter, but the average score (of all 100 snakes in the population) will converge to a certain value, the problem is that the input to the neural network only tells the snake whether the cell beside its head is clear or not, so the snake doesn't know whether there is an obstacle on its path to the food or not. Therefore, once the snake grows longer, it gets harder for the snake to escape from the its tail and the wall.  

Example of snake that hits its own body :(  
![ScreenShot](/screenshot/deadSnake.png?raw=true "dead_snake")  