Code.require_file "../../lib/neurons_neural_networks_and_linear_discriminants/perceptron.ex", __DIR__
Code.require_file "../../lib/algebra/matrix.ex", __DIR__

ExUnit.start()
defmodule NeuronsNeuralNetworksAndLinearDiscriminants.PerceptronTest do
  use ExUnit.Case, async: false

  alias NeuronsNeuralNetworksAndLinearDiscriminants.Perceptron
  alias Algebra.Matrix

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

      weights =
        Perceptron.training(
          training_data,
          context[:weights],
          context[:activation],
          learning_rate,
          training_epochs
        )

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

    test "learns to classify Pima Indians with diabetes using\
          (plasma glucose concentration and 2-Hourse serum insulin [mu U/ml])", context do
      # The data is from https://archive.ics.uci.edu/ml/datasets/pima+indians+diabetes
      # Data columns (the data is without header row and load into a matrix with starting index `0, 0`)
      # 1. Number of times pregnant
      # 2. Plasma glucose concentration a 2 hours in an oral glucose tolerance test
      # 3. Diastolic blood pressure (mm Hg)
      # 4. Triceps skin fold thickness (mm)
      # 5. 2-Hour serum insulin (mu U/ml)
      # 6. Body mass index (weight in kg/(height in m)^2)
      # 7. Diabetes pedigree function
      # 8. Age (years)
      # 9. Class variable (0 or 1)

      # Data loading, cleaning, and splitting to training and test

      {:ok, data} = File.read("data/pima-indians-diabetes.data")

      data =
        data
        |> String.trim
        |> String.split("\n")
        |>  Enum.map(fn string ->
              String.split(string, ",")
              |>  Enum.map(fn str ->
                    {number, _} = Float.parse(str)
                    number
                  end)
            end)

      reduced_data = data |> Matrix.extract_columns([1, 4, 8])

      data_size = length(reduced_data)
      unordered_data = reduced_data |> Enum.shuffle

      {training_data, test_data} = # Split to {80%, 20%}
        unordered_data
        |> Enum.split(round(0.8 * data_size))

      # Training
      # Adding the bias to the input
      training_data =
        training_data
        |>  Enum.map(fn [glucose_conc, insulin_level, target] ->
              [input: [-1, glucose_conc, insulin_level], target: target]
            end)

      learning_rate = 0.1
      training_epochs = 50

      weights =
        Perceptron.training(
          training_data,
          context[:weights],
          context[:activation],
          learning_rate,
          training_epochs
        )

      # Test how well the perceptron learned
      total_number_of_examples = length(test_data)

      accuracy =
        Enum.reduce(test_data, 0, fn [glucose_conc, insulin_level, target], acc ->
          result =
            if Perceptron.prediction([glucose_conc, insulin_level], weights, context[:activation]) == target,
              do: 1, else: 0

          acc + result
        end)
        |> Kernel./(total_number_of_examples)

      assert accuracy > 0.5 # It is better than random guess :)
    end
  end
end
