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
  def line_coefficients(x, y) do
    x_inverse = Matrix.transpose(x) |> Matrix.multiply(x) |> Matrix.inverse

    Matrix.multiply(x_inverse, Matrix.transpose(x))
    |> Matrix.multiply(y)
    |> Matrix.transpose
    |> Enum.at(0)
  end

  @doc """
  Predicts base on the approximated line and threshold function.
  """
  def prediction(input, line_coefficients, threshold) do
    y = line(input, line_coefficients)
    if threshold.(y), do: 1, else: 0
  end

  defp line(x, [b, m]), do: b + m * x
end
