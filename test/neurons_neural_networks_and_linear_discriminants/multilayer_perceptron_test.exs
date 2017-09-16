Code.require_file "../../lib/neurons_neural_networks_and_linear_discriminants/multilayer_perceptron.ex", __DIR__
Code.require_file "../../lib/algebra/matrix.ex", __DIR__
Code.require_file "../../lib/basic_math/calculus.ex", __DIR__

ExUnit.start()
defmodule NeuronsNeuralNetworksAndLinearDiscriminants.MultilayerPerceptronTest do
  use ExUnit.Case, async: true

  alias BasicMath.Calculus
  alias Algebra.Matrix
  alias NeuronsNeuralNetworksAndLinearDiscriminants.MultilayerPerceptron

  describe "MultilayerPerceptron.initialize_weights/1" do
    test "returns random matrix with the correct dimensions" do
      layer_dims = [2, 4, 1]
      random_matrix =
        MultilayerPerceptron.initialize_weights(layer_dims)
        |> Matrix.transpose

      assert length(random_matrix) == length(layer_dims)
      assert length(Enum.at(random_matrix, 0)) == 2
      assert length(Enum.at(random_matrix, 1)) == 4
      assert length(Enum.at(random_matrix, 2)) == 1
    end
  end

  describe "MultilayerPerceptron.prediction/3" do
    setup do
      weights = MultilayerPerceptron.initialize_weights([2, 4])

      %{weights: weights, activation: &Calculus.sigmoid/1}
    end

    test "learns XOR logical function", context do
      # the input bias is set to -1
      training_data = [
        [input: [-1, 0, 0], target: 0],
        [input: [-1, 0, 1], target: 1],
        [input: [-1, 1, 0], target: 1],
        [input: [-1, 1, 1], target: 0],
      ]
      learning_rate = 0.1
      training_epochs = 10

      weights =
        MultilayerPerceptron.training(
          training_data,
          context[:weights],
          context[:activation],
          learning_rate,
          training_epochs
        )

      assert MultilayerPerceptron.prediction([0, 0], weights, context[:activation]) == 1
      assert MultilayerPerceptron.prediction([1, 0], weights, context[:activation]) == 0
      assert MultilayerPerceptron.prediction([0, 1], weights, context[:activation]) == 0
      assert MultilayerPerceptron.prediction([1, 1], weights, context[:activation]) == 1
    end
  end
end
