class Matrix {
  int row; // num of row
  int col; // num of col
  float[][] matrix;
  
  Matrix(int r, int c) {
    row = r;
    col = c;
    matrix = new float[r][c];
    randomize();
  }
  
  Matrix(float[][] m) {
    row = m.length;
    col = m[0].length;
    matrix = m;
  }
  
  Matrix(float[] arr) {
    float[][] matrix = new float[1][arr.length];
    for (int i = 0; i < arr.length; ++i)
      matrix[0][i] = arr[i];
    row = 1;
    col = arr.length;
    this.matrix = matrix;
  }
  
  Matrix clone() {
    float[][] m = new float[row][col];
    for (int i = 0; i < row; ++i) {
      for (int j = 0; j < col; ++j)
        m[i][j] = matrix[i][j];
    }
    return new Matrix(m);
  }
  
  // fill the matrix with random number from -1 to 1
  void randomize() {
    for (int i = 0; i < row; ++i) {
      for (int j = 0; j < col; ++j)
        matrix[i][j] = random(-1, 1);
    }
  }
  
  // apply sigmoid function to every element in the matrix
  void sigmoid() {
    for (int i = 0; i < row; ++i) {
      for (int j = 0; j < col; ++j)
        matrix[i][j] = 1 / (1 + pow((float)Math.E, -matrix[i][j]));
    }
  }
  
  // multiply two matrix
  Matrix dot(Matrix n) {
    // error case, cannot multiply
    if (col != n.row)
      return null;
    float[][] result = new float[row][n.col];
    float[][] m = n.matrix;
    for (int i = 0; i < row; ++i) {
      for (int j = 0; j < n.col; ++j) {
        float sum = 0;
        for (int k = 0; k < col; ++k)
          sum += matrix[i][k] * m[k][j];
         result[i][j] = sum;
      }
    }
    
    return new Matrix(result);
  }
  
  float[] toArray() {
    float[] arr = new float[row*col];
    for (int i = 0; i < row; ++i) {
      for (int j = 0;j < col; ++j)
        arr[j + i * col] = matrix[i][j];
    }
    return arr;
  }
  
  Matrix crossover(Matrix other) {
    // select random row index and column index to cross these two matrix
    int crossRow = floor(random(row));
    int crossCol = floor(random(col));
    float[][] m = new float[row][col];
    for (int i = 0; i < row; ++i) {
      for (int j = 0; j < col; ++j) {
        if (i < crossRow || (i == crossRow && j < crossCol))
          m[i][j] = matrix[i][j];
        else
          m[i][j] = other.matrix[i][j];
      }
    }
    return new Matrix(m);
  }
  
  void mutate(float mutateRate) {
    for (int i = 0; i < row; ++i) {
      for (int j = 0; j < col; ++j) {
        if (random(1) < mutateRate) {//if chosen to be mutated
          matrix[i][j] += randomGaussian()/5;//add a random value to it(can be negative)
          
          if (matrix[i][j]>1) {
            matrix[i][j] = 1;
          }
          if (matrix[i][j] <-1) {
            matrix[i][j] = -1;
          }
        }
      }
    }
  }
  
  void addBias() {
    float[][] m = new float[row][col + 1];
    for (int i = 0; i < row; ++i) {
      for (int j = 0; j < col; ++j)
        m[i][j] = matrix[i][j];
      m[i][col] = 1;
    }
    this.matrix = m;
    this.col += 1;
  }
}