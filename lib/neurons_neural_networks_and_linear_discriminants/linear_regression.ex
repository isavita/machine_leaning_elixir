Code.require_file "../algebra/matrix.ex", __DIR__
Code.require_file "../algebra/vector.ex", __DIR__

defmodule NeuronsNeuralNetworksAndLinearDiscriminants.LinearRegression do
  @moduledoc """
  Provides implementation of linear regression.
  """

  alias Algebra.{Matrix, Vector}

  @doc """
  Calculates the intersection with the y-axis `b` and the slop `m` (e.g. y = b + m * x).
  Returns [b, m].
  """
  def line_coefficients(x, y), do: multidimensional_plane_coefficients(x, y)

  @doc """
  Calculates the the multidimensional plane's coefficients (e.g. y = b0 + b1 * x1 + ... + bn * xn).
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
