Code.require_file "../../lib/neurons_neural_networks_and_linear_discriminants/linear_regression.ex", __DIR__
Code.require_file "../../lib/algebra/matrix.ex", __DIR__
Code.require_file "../../lib/basic_math/statistics.ex", __DIR__

ExUnit.start()
defmodule NeuronsNeuralNetworksAndLinearDiscriminants.LinearRegressionTest do
  use ExUnit.Case, async: true

  alias NeuronsNeuralNetworksAndLinearDiscriminants.LinearRegression
  alias Algebra.Matrix
  alias BasicMath.Statistics

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

  describe "LinearRegression.categorize/3" do
    test "approximates NOT logical function", context do
      line_coefficients = LinearRegression.line_coefficients(context[:x], context[:y])

      assert LinearRegression.categorize(0, line_coefficients, context[:threshold]) == 1
      assert LinearRegression.categorize(1, line_coefficients, context[:threshold]) == 0
    end
  end

  describe "LinearRegression.prediction/2" do
    test "predicts the fuel efficiency in miles per gallon (mpg)" do
      # The data source https://archive.ics.uci.edu/ml/datasets/auto+mpg
      # Data columns (the data is without header row and load into a matrix with starting index `0, 0`)
      # 1. mpg:           continuous
      # 2. cylinders:     multi-valued discrete
      # 3. displacement:  continuous
      # 4. horsepower:    continuous
      # 5. weight:        continuous
      # 6. acceleration:  continuous
      # 7. model year:    multi-valued discrete
      # 8. origin:        multi-valued discrete
      # 9. car name:      string (unique for each instance)

      # Data loading, cleaning, and splitting to training and test

      {:ok, data} = File.read("data/auto-mpg.data")

      number_of_features = 8

      data =
        data
        |> String.trim
        |> String.split("\n")
        |> Enum.map(fn string ->
             string
             |> String.replace(~r{\t?".+"}, "")
             |> String.split("\s")
             |> Enum.map(fn str ->
                  with {number, _} <- Float.parse(str) do
                    number
                  else
                    error -> nil
                  end
               end)
             |> Enum.reject(&is_nil/1)
           end)
        |> Enum.reject(fn sample -> length(sample) < number_of_features end)

      # Data rescaling to range [0, 1]
      data =
        data
        |> Matrix.transpose
        |> Enum.map(&Statistics.rescaling(&1, [0, 1]))
        |> Matrix.transpose

      number_of_samples = length(data)
      unordered_data = Enum.shuffle(data)

      {training_data, test_data} = # Split to {80%, 20%}
        unordered_data
        |> Enum.split(round(0.8 * number_of_samples))

      # Training (function approximation)
      x_training_data = Matrix.extract_columns(training_data, [3, 4, 5])
      y_training_data = Matrix.extract_columns(training_data, [0])

      plane_coefficients = LinearRegression.multidimensional_plane_coefficients(x_training_data, y_training_data)

      # Test how good is the linear model (Did we approximate the function well?)
      x_test_data = Matrix.extract_columns(test_data, [3, 4, 5])
      y_test_data = Matrix.extract_columns(test_data, [0]) |> Matrix.transpose |> Enum.at(0)

      predictions =
        x_test_data
        |> Enum.map(fn sample -> LinearRegression.prediction(sample, plane_coefficients) end)

      sum_of_squares_error =
        Enum.zip(y_test_data, predictions)
        |> Enum.map(fn {y, predicted} -> :math.pow(y - predicted, 2) end)
        |> Enum.sum
        |> :math.sqrt

      assert sum_of_squares_error < 200 # More rescaling and better features picking needed!!!
    end
  end
end
