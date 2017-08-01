defmodule Algebra.Vector do
  @moduledoc """
  Provides base vector algebra operations.

  ## Examples

    iex> Algebra.Vector.dot_prod([1, 1, 3.4], [2.8, 3, 1])
    9.2

    iex> Algebra.Vector.dot_prod({1, 1, 3.4}, {2.8, 3, 1})
    9.2

  """

  @doc """
  Calculates the dot product of two list or tuple vectors
  """
  def dot_prod(a, b) when is_list(a) and is_list(b) do
    [a, b]
    |> Enum.zip
    |> Enum.reduce(0, fn {x, y}, prod -> prod + x * y end)
  end
  def dot_prod(a, b) when is_tuple(a) and is_tuple(b), do: dot_prod(Tuple.to_list(a), Tuple.to_list(b))
  def dot_prod(_, _), do: raise ArgumentError, "invalid argument"
end
