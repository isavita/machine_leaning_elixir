Code.require_file "../lib/logistic_regression.ex", __DIR__
Code.require_file "../lib/basic_math/calculus.ex", __DIR__

ExUnit.start()
defmodule LogisticRegressionTest do
  use ExUnit.Case, async: true

  alias BasicMath.Calculus

  @epsilon_precision 0.00001

  describe "LogisticRegression.loss/2" do
    test "returns the loss for given data sample" do
      assert_in_delta LogisticRegression.loss(Calculus.sigmoid(0.5), 0.5), 0.72407, @epsilon_precision
    end
  end

  describe "LogisticRegression.prediction/3" do
    test "Learning AND logical function" do
      # Logistic Regression implementation follows vectorized implementation form
      # Andrew Ng course for deep learning (https://www.coursera.org/specializations/deep-learning).
      # Training
      training_data = [
        [0, 0],
        [0, 1],
        [1, 0],
        [1, 1]
      ]

      y = [[0], [0], [0], [1]]
      weights = [[0, 0]]
      bias = -1
      learning_rate = 0.3

      {weights, bias} = LogisticRegression.training(training_data, y, weights, bias, learning_rate, 1_000)

      refute LogisticRegression.prediction([0, 0], weights, bias) > 0.5
      refute LogisticRegression.prediction([0, 1], weights, bias) > 0.5
      refute LogisticRegression.prediction([1, 0], weights, bias) > 0.5
      assert LogisticRegression.prediction([1, 1], weights, bias) > 0.9 # The level of confidance is more than 90%
    end
  end
end
