Code.require_file "algebra/matrix.ex", __DIR__
Code.require_file "basic_math/calculus.ex", __DIR__

defmodule LogisticRegression do
  @moduledoc """
  Provides implementation of Logistic Regression with gradient descent method for calculating
  the weights and the bias.
  """

  alias Algebra.Matrix
  alias BasicMath.Calculus

  @doc """
  Predicts base on learned weights and the bias.
  """
  def prediction(input, weights, bias) do
    Matrix.multiply_column_vector(weights, input)
    |> List.flatten
    |> Enum.sum
    |> Kernel.+(bias)
    |> Calculus.sigmoid
  end

  @doc """
  Learns the function approximation.
  """
  @spec training(Matrix.matrix, list, Matrix.matrix, number, number) :: {Matrix.matrix, number}
  def training(samples, y, weights, bias, training_rate, training_epochs \\ 1)
  def training(_, _, weights, bias, _, 0), do: {weights, bias}
  def training(samples, y, weights, bias, learning_rate, training_epochs) do
    {weights, bias} = update_weights(samples, y, weights, bias, learning_rate)
    training(samples, y, weights, bias, learning_rate, training_epochs - 1)
  end

  defp update_weights(samples, y, weights, bias, learning_rate) do
    number_of_samples = length(samples)
    z =
      Matrix.multiply(samples, Matrix.transpose(weights))
      |> Matrix.scalar_element_wise_operation(bias, &+/2)

    guesses = Matrix.element_wise_fun(z, &Calculus.sigmoid/1)
    total_error = cost(guesses, y)

    dz = Matrix.sub(guesses, y)
    dz_average =
      dz
      |> List.flatten
      |> Enum.sum
      |> Kernel./(number_of_samples)

    dz_vector = dz |> Matrix.transpose |> Enum.at(0)
    dweights =
      Matrix.column_wise_operation(samples, dz_vector, &*/2)
      |> Matrix.transpose
      |> Enum.map(&(Enum.sum(&1) / number_of_samples))

    weights = Matrix.sub(weights, Matrix.scalar_element_wise_operation([dweights], learning_rate, &*/2))
    bias = bias - learning_rate * dz_average

    {weights, bias}
  end

  @doc """
  Calculates the error for the whole training set.
  """
  @spec cost(Matrix.matrix, Matrix.matrix) :: number
  def cost(guesses, real_values) do
    Matrix.element_wise_fun(guesses, real_values, &loss/2)
    |> List.flatten
    |> Enum.sum
    |> Kernel./(length(guesses))
  end

  @doc """
  Calculates the error for a single example.
  """
  @spec loss(number, number) :: number
  def loss(guess, real), do: do_loss(guess, real)

  defp do_loss(a, y) do
    -(y * :math.log(a) + (1 - y) * :math.log(1 - a))
  end
end
