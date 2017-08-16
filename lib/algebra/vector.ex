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
  Adds to each element of the vector the scalar.
  """
  @spec add_scalar(list, number) :: list
  def add_scalar(vector, scalar), do: vector_scalar_op(vector, scalar, &+/2)

  @doc """
  Substracts from each element of the vector the scalar.
  """
  @spec sub_scalar(list, number) :: list
  def sub_scalar(vector, scalar), do: vector_scalar_op(vector, scalar, &-/2)

  @doc """
  Calculates the product between a vector and scalar.
  """
  @spec multiply_scalar(list, number) :: list
  def multiply_scalar(vector, scalar), do: vector_scalar_op(vector, scalar, &*/2)

  @doc """
  Adds two vectors.
  """
  @spec add(list, list) :: list
  def add(vector_a, vector_b), do: element_wise_op(vector_a, vector_b, &+/2)

  @doc """
  Subtracts two vectors.
  """
  @spec sub(list, list) :: list
  def sub(vector_a, vector_b), do: element_wise_op(vector_a, vector_b, &-/2)

  @doc """
  Divides two vectors.
  """
  @spec div_element_wise(list, list) :: list
  def div_element_wise(vector_a, vector_b), do: element_wise_op(vector_a, vector_b, &//2)

  @doc """
  Multiplies two vectors (a.k.a Hadamard product).
  """
  @spec hadamard_prod(list, list) :: list
  def hadamard_prod(vector_a, vector_b), do: element_wise_op(vector_a, vector_b, &*/2)

  @spec element_wise_op(list, list, fun) :: list
  defp element_wise_op(vector_a, vector_b, operation) when length(vector_a) == length(vector_b) do
    [vector_a, vector_b]
    |> Enum.zip
    |> Enum.map(fn {a, b} -> operation.(a, b) end)
  end
  defp element_wise_op(_, _, _), do: raise ArgumentError, "the vectors have to be with equal lengths"

  @spec vector_scalar_op(list, number, fun) :: list
  def vector_scalar_op(vector, scalar, operation) when is_list(vector) and is_number(scalar) do
    Enum.map(vector, &operation.(&1, scalar))
  end
  def vector_scalar_op(_, _, _), do: raise ArgumentError, "invalid argument"
end
