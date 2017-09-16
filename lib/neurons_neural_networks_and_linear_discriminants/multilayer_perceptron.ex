Code.require_file "../algebra/matrix.ex", __DIR__
Code.require_file "../algebra/vector.ex", __DIR__

defmodule NeuronsNeuralNetworksAndLinearDiscriminants.MultilayerPerceptron do
  @moduledoc """
  Provides implementation of multilayer perceptron.
  """

  alias Algebra.{Matrix, Vector}

  @doc """
  Initializes the weights for all layers with numbers between
  -1 / (2 * sqrt(layer_size)) < weight < 1 / (2 * sqrt(layer_size)).
  """
  def initialize_weights(layers) do
    do_initialize_weights(layers, [])
    |> Enum.reverse
    |> Matrix.transpose
  end

  defp do_initialize_weights([], weights), do: weights
  defp do_initialize_weights([dim | dims], weights) do
    row = random_vector(dim, []) |> Enum.map(&(&1 / :math.sqrt(dim)))
    do_initialize_weights(dims, [row | weights])
  end

  defp random_vector(size, vector) when size <= 0, do: vector
  defp random_vector(size, vector) do
    random_number = 0.5 - :rand.uniform
    random_vector(size - 1, [random_number | vector])
  end

  @doc """
  Performs feed forward propagation.
  """
  def feed_farward_propagation do

  end
end
