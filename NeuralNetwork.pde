class NeuralNetwork {
  Matrix ih; // weight for matrix between input node and hidden layer 1
  Matrix ho; // weight for matrix between hidden layer 2 and output layer
  
  NeuralNetwork(int input, int h, int output) {
    ih = new Matrix(input, h);
    ho = new Matrix(h + 1, output);
  }
  
  NeuralNetwork(Matrix m1, Matrix m2) {
    ih = m1;
    ho = m2;
  }
  
  NeuralNetwork clone() {
    return new NeuralNetwork(ih.clone(), ho.clone());
  }
  
  float[] output(float[] inputArr) {
    Matrix input = new Matrix(inputArr);
    //input.addBias();
    Matrix h = input.dot(ih);
    h.sigmoid();
    h.addBias();
    Matrix output = h.dot(ho);
    output.sigmoid();
    return output.toArray();
  }
  
  NeuralNetwork crossover(NeuralNetwork other) {
    return new NeuralNetwork(ih.crossover(other.ih),
                             ho.crossover(other.ho));
  }
  
  void mutate(float mutateRate) {
    ih.mutate(mutateRate);
    ho.mutate(mutateRate);
  }
}