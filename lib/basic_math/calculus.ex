defmodule BasicMath.Calculus do
  @moduledoc """
  Provides basic calculus functions for machine learning.

  ### Examples

    iex> Calculus.sigmoid(0)
    0.5

    iex> Calculus.sigmoid_derivative(0)
    0.25
  """

  @doc """
  Calculates the sigmoid function often used for activation function in machine learning algorithms.
  """
  @spec sigmoid(number) :: number
  def sigmoid(x) do
    1 / (1 + :math.exp(-x))
  end

  @doc """
  Calculates the first sigmoid derivative.
  """
  @spec sigmoid_derivative(number) :: number
  def sigmoid_derivative(x) do
    sigmoid(x) * (1 - sigmoid(x))
  end
end
