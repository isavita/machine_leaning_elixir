Code.require_file "../../lib/neurons_neural_networks_and_linear_discriminants/linear_regression.ex", __DIR__
Code.require_file "../../lib/algebra/matrix.ex", __DIR__

ExUnit.start()
defmodule NeuronsNeuralNetworksAndLinearDiscriminants.LinearRegressionTest do
  use ExUnit.Case, async: true

  alias NeuronsNeuralNetworksAndLinearDiscriminants.LinearRegression
  alias Algebra.Matrix

  setup do
    x = [[1, 0], [1, 1]] # given input paginated with ones
    y = [[1], [0]] # the correct output
    threshold = fn x when x >= 0.5 -> true; _ -> false end

    [x: x, y: y, threshold: threshold]
  end

  describe "LinearRegression.line_coefficients/2" do
    test "returns the y-axis interception point `b` and the slop `m` as list [b, m] for the logical NOT", context do
      assert LinearRegression.line_coefficients(context[:x], context[:y]) == [0.75, -0.5]
    end
  end

  describe "LinearRegression.prediction/3" do
    test "approximates NOT logical function", context do
      line_coefficients = LinearRegression.line_coefficients(context[:x], context[:y])

      assert LinearRegression.prediction(0, line_coefficients, context[:threshold]) == 1
      assert LinearRegression.prediction(1, line_coefficients, context[:threshold]) == 0
    end
  end
end
