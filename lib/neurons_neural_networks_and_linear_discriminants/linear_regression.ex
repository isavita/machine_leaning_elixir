Code.require_file "../algebra/matrix.ex", __DIR__
Code.require_file "../algebra/vector.ex", __DIR__
Code.require_file "../basic_math/statistics.ex", __DIR__

defmodule NeuronsNeuralNetworksAndLinearDiscriminants.LinearRegression do
  @moduledoc """
  Provides implementation of linear regression.
  """

  alias Algebra.{Matrix, Vector}
  alias BasicMath.{Statistics}

  @doc """
  Calculates the intersection with the y-axis `b` and the slop `m` (e.g. y = b + m * x).
  Returns [b, m].
  """
  def line_coefficients(x, y), do: multidimensional_plane_coefficients(x, y)

  @doc """
  Calculates the multidimensional plane's coefficients (e.g. y = b0 + b1 * x1 + ... + bn * xn).
  Returns [b0, b1, b2, ..., bn].
  """
  def multidimensional_plane_coefficients(x, y) do
    x_inverse = Matrix.transpose(x) |> Matrix.multiply(x) |> Matrix.inverse

    Matrix.multiply(x_inverse, Matrix.transpose(x))
    |> Matrix.multiply(y)
    |> Matrix.transpose
    |> Enum.at(0)
  end

  @doc """
  Calculates the multidimensional approximation using stochastic gradient descent method.
  """
  def multidimensional_plane_coefficients_with_gradient_descent(samples, real_values, coefficients, learning_rate, bias, epochs \\ 1)
  def multidimensional_plane_coefficients_with_gradient_descent(_, _, coefficients, _, bias, 0), do: {coefficients, bias}
  def multidimensional_plane_coefficients_with_gradient_descent(samples, real_values, coefficients, learning_rate, bias, epochs) do
    {coefficients, bias} = one_epoch(samples, real_values, coefficients, learning_rate, bias)
    multidimensional_plane_coefficients_with_gradient_descent(samples, real_values, coefficients, learning_rate, bias, epochs - 1)
  end

  defp one_epoch([], [], coefficients, bias, _), do: {coefficients, bias}
  defp one_epoch([sample | samples], [real_value | real_values], coefficients, learning_rate, bias) do
    {coefficients, bias} = coefficients_update(sample, real_value, coefficients, learning_rate, bias)
    one_epoch(samples, real_values, coefficients, learning_rate, bias)
  end

  defp coefficients_update(sample, real_value, coefficients, learning_rate, bias) do
    guess = Vector.dot_prod(coefficients, sample)
    error = guess - real_value
    bias = bias - learning_rate * error
    corrections = Vector.multiply_scalar(sample, learning_rate * error)
    {Vector.sub(coefficients, corrections), bias}
  end

  @doc """
  Categorizes base on the approximated line and threshold function.
  """
  def categorize(input, line_coefficients, threshold) do
    y = line(input, line_coefficients)
    if threshold.(y), do: 1, else: 0
  end

  @doc """
  Predicts base on the approximated multidimensional plane.
  """
  def prediction(input_vector, plane_coefficients) do
    multidimensional_plane(input_vector, plane_coefficients)
  end

  defp line(x, [b, m]), do: b + m * x

  defp multidimensional_plane(x, coefficients) do
    [b0 | bs] = coefficients
    Vector.dot_prod(x, bs) + b0
  end
end
