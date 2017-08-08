Code.require_file "../../lib/neurons_neural_networks_and_linear_discriminants/perceptron.ex", __DIR__

ExUnit.start()
defmodule NeuronsNeuralNetworksAndLinearDiscriminants.PerceptronTest do
  use ExUnit.Case, async: false

  alias NeuronsNeuralNetworksAndLinearDiscriminants.Perceptron

  describe "Perceptron.prediction/3" do
    setup do
      weights = [
        [-0.1, 0.2, -0.17]
      ]
      activation_fun = fn x when x > 0 -> 1; _ -> 0 end

      [weights: weights, activation: activation_fun]
    end

    test "learns AND logical function", context do
      # the input bias is set to -1
      training_data = [
        [input: [-1, 0, 0], target: 0],
        [input: [-1, 0, 1], target: 0],
        [input: [-1, 1, 0], target: 0],
        [input: [-1, 1, 1], target: 1],
      ]
      learning_rate = 0.1
      training_epochs = 5

      weights = Perceptron.training(training_data, context[:weights], context[:activation], learning_rate, training_epochs)

      assert Perceptron.prediction([0, 0], weights, context[:activation]) == 0
      assert Perceptron.prediction([1, 0], weights, context[:activation]) == 0
      assert Perceptron.prediction([0, 1], weights, context[:activation]) == 0
      assert Perceptron.prediction([1, 1], weights, context[:activation]) == 1
    end

    test "learns OR logical function", context do
      # the input bias is set to -1
      training_data = [
        [input: [-1, 0, 0], target: 0],
        [input: [-1, 0, 1], target: 1],
        [input: [-1, 1, 0], target: 1],
        [input: [-1, 1, 1], target: 1],
      ]
      learning_rate = 0.2
      training_epochs = 5

      weights = Perceptron.training(training_data, context[:weights], context[:activation], learning_rate, training_epochs)

      assert Perceptron.prediction([0, 0], weights, context[:activation]) == 0
      assert Perceptron.prediction([1, 0], weights, context[:activation]) == 1
      assert Perceptron.prediction([0, 1], weights, context[:activation]) == 1
      assert Perceptron.prediction([1, 1], weights, context[:activation]) == 1
    end
  end
end
