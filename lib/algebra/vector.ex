defmodule Algebra.Vector do
  @moduledoc """
  Provides base vector algebra operations.

  ## Examples

    iex> Algebra.Vector.dot_prod([1, 1, 3.4], [2.8, 3, 1])
    9.2

    iex> Algebra.Vector.multiply_scalar([1, 1, 3.4], -3)
    [-3, -3, -10.2]

    iex> Algebra.Vector.add([1, 1, 3.4], [-1, 2, 3.6])
    [0, 3, 7.0]

    iex> Algebra.Vector.sub([1, 1, 3.4], [-1, 2, 3.4])
    [2, -1, 0.0]
  """

  @doc """
  Calculates the dot product of two vectors.
  """
  @spec dot_prod(list, list) :: list
  def dot_prod(vector_a, vector_b) when is_list(vector_a) and is_list(vector_b) do
    [vector_a, vector_b]
    |> Enum.zip
    |> Enum.reduce(0, fn {a, b}, prod -> prod + a * b end)
  end
  # TODO: drop support for tuples if not needed.
  def dot_prod(vector_a, vector_b) when is_tuple(vector_a) and is_tuple(vector_b) do
    dot_prod(Tuple.to_list(vector_a), Tuple.to_list(vector_b))
  end
  def dot_prod(_, _), do: raise ArgumentError, "invalid argument"

  @doc """
  Calculates the product between a vector and scalar.
  """
  @spec multiply_scalar(list, number) :: list
  def multiply_scalar(vector, scalar) when is_list(vector) and is_number(scalar) do
    vector |> Enum.map(&(&1 * scalar))
  end
  def multiply_scalar(_, _), do: raise ArgumentError, "invalid argument"

  @doc """
  Adds two vectors.
  """
  @spec add(list, list) :: list
  def add(vector_a, vector_b) do
    element_wise_op(vector_a, vector_b, &+/2)
  end

  @doc """
  Subtracts two vectors.
  """
  @spec sub(list, list) :: list
  def sub(vector_a, vector_b) do
    element_wise_op(vector_a, vector_b, &-/2)
  end

  @spec element_wise_op(list, list, fun) :: list
  defp element_wise_op(vector_a, vector_b, operation) when length(vector_a) == length(vector_b) do
    [vector_a, vector_b]
    |> Enum.zip
    |> Enum.map(fn {a, b} -> operation.(a, b) end)
  end
  defp element_wise_op(_, _, _), do: raise ArgumentError, "the vectors have to be with equal lengths"
end
