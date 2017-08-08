Code.require_file "../algebra/matrix.ex", __DIR__
Code.require_file "../algebra/vector.ex", __DIR__

defmodule NeuronsNeuralNetworksAndLinearDiscriminants.Perceptron do
  alias Algebra.{Matrix, Vector}

  def prediction(input, weights, activation_fun, bias \\ -1) do
    do_prediction([bias | input], weights, activation_fun)
  end

  def training(training_data, weights, activation_fun, learning_rate \\ 0.1, epochs \\ 1) do
    do_training(training_data, weights, activation_fun, learning_rate, epochs)
  end

  defp do_training(_, weights, _, _, 0), do: weights
  defp do_training(training_data, weights, activation_fun, learning_rate, epochs) do
    weights = one_epoch_iteration(training_data, weights, activation_fun, learning_rate)
    do_training(training_data, weights, activation_fun, learning_rate, epochs - 1)
  end

  defp one_epoch_iteration([], weights, _, _), do: weights
  defp one_epoch_iteration([[input: input, target: target] | tail_data], weights, activation_fun, learning_rate) do
    prediction = do_prediction(input, weights, activation_fun)
    weights = update_weights(weights, input, prediction, target, learning_rate)
    one_epoch_iteration(tail_data, weights, activation_fun, learning_rate)
  end

  defp update_weights(weights, _, prediction, target, _) when prediction == target, do: weights
  defp update_weights(weights, input, prediction, target, learning_rate) do
    delta_vector = Vector.multiply_scalar(input, learning_rate * (prediction - target))
    Enum.map(weights, fn weight_row -> Vector.sub(weight_row, delta_vector) end)
  end

  defp do_prediction(input, weights, activation_fun) do
    Matrix.multiply_row_vector(input, Matrix.transpose(weights)) |> Enum.sum |> activation_fun.()
  end
end
