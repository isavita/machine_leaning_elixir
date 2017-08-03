defmodule Algebra.Matrix do
  @moduledoc """
  Provides base matrix algebra operations.

  ## Examples

    iex> Algebra.Matrix.identity(3)
    [[1, 0, 0], [0, 1, 0], [0, 0, 1]]

    iex> > Algebra.Matrix.transpose([[1, 3, 5], [2, 4, 7]])
    [[1, 2], [3, 4], [5, 7]]

    iex> Algebra.Matrix.det([[1, 2], [3, 4]])
    -2
  """

  @doc """
  Creates identity matrix with specified size.
  """
  def identity(size) when is_integer(size) and size > 0 do
    0..(size - 1)
    |> Enum.to_list
    |> Enum.map(fn pos -> List.duplicate(0, size - 1) |> List.insert_at(pos, 1) end)
  end
  def identity(_), do: raise ArgumentError, "the identity matrix's size has to be a positive integer"

  @doc """
  Calculates the transposed matrix.
  """
  def transpose([[]]), do: [[]]
  def transpose([a]) when not is_list(a), do: raise ArgumentError, "the matrix has to be represented by a nested list"
  def transpose(a) when is_list(a), do: a |> Enum.zip |> Enum.map(&Tuple.to_list/1)
  def transpose(_), do: raise ArgumentError, "the matrix has to be represented by a nested list"

  @doc """
  Gets diagonal elements of matrix.
  """
  def diag(matrix) do
    do_diag(matrix, 0)
  end

  defp do_diag([], _), do: []
  defp do_diag([head | tail], j) when length(head) <= j , do: []
  defp do_diag([head | tail], j) do
    [Enum.at(head, j) | do_diag(tail, j + 1)]
  end

  @doc """
    Subtracts matrices with the same dimensionality.
  """
  def sub(matrix_a, matrix_b) when length(matrix_a) != length(matrix_b) do
    raise ArgumentError, "the matrices have to be the same dimensions"
  end
  def sub([row_a | _], [row_b | _]) when length(row_a) != length(row_b) do
    raise ArgumentError, "the matrices have to be the same dimensions"
  end
  def sub(matrix_a, matrix_b) do
    Enum.zip(matrix_a, matrix_b)
    |> Enum.map(fn {row_a, row_b} -> Enum.zip(row_a, row_b) |> Enum.map(fn {a, b} -> a - b end) end)
  end

  @doc """
  Calculates a pivot matrix used for numerical stability.
  """
  def pivot_matrix(matrix) do
    matrix |> lup_decomposition |> elem(2)
  end

  @doc """
  Calculates the LUP decomposition of square matrix.
  The permutation matrix is stored as a vector of integer containing
  column indexes where the permutation matrix has "1".
  """
  def lup_decomposition(matrix) do
    size = length(matrix)
    p_vector = 0..size |> Enum.to_list
    {dec_matrix, p_vector} = do_lup_decomposition(matrix, p_vector, size, 0)
    l = 0 # TODO implement calc_l_from_decompose_matrix
    u = 0 # TODO implement calc_u_from_decompose_matrix
    {l, u, calc_p_from_p_vector(p_vector)}
  end

  defp do_lup_decomposition(matrix, p_vector, size, i) when size <= i, do: {matrix, p_vector}
  defp do_lup_decomposition(matrix, p_vector, size, i) do
    max_index = matrix
      |> transpose
      |> Enum.at(i)
      |> Enum.with_index
      |> Enum.filter(fn {_, index} -> index >= i end)
      |> Enum.max_by(fn {x, _} -> abs(x) end)
      |> elem(1)

    p_vector = case {i, max_index} do
      {i, i} -> p_vector
      _ -> swap_elements(p_vector, i, max_index) |> List.update_at(size, &(&1 + 1))
    end

    matrix = case {i, max_index} do
      {i, i} -> matrix
      _ -> swap_raws(matrix, i, max_index)
    end

    matrix = matrix |> update_matrix(i, i + 1, size)

    do_lup_decomposition(matrix, p_vector, size, i + 1)
  end

  # The p_vector contains column indexes where permutation matrix P has "1" and
  # as a last element the size of the matrix A plus the number of permutations done
  # during LUP decomposition.
  defp calc_p_from_p_vector(p_vector) do
    size = length(p_vector) - 2 # the matrix's indexes start from 0
    p_vector
    |> Enum.drop(-1)
    |> Enum.map(fn pos -> List.duplicate(0, size) |> List.insert_at(pos, 1) end)
  end

  defp calc_l_from_decompose_matrix(matrix) do
    matrix |> sub(identity(length(matrix)))
  end

  @doc """
  Calculates the determinant of square matrix using LU decomposition.
  """
  def det([[]]), do: 0
  def det([[n]]) when is_number(n), do: n
  def det([h | t] = matrix) when length(h) == length(matrix) do
    size = length(matrix)
    p_vector = 0..size |> Enum.to_list
    {dec_matrix, p_vector} = do_lup_decomposition(matrix, p_vector, size, 0)
    sign = :math.pow(-1, Enum.at(p_vector, -1) - size)
    dec_matrix
    |> diag()
    |> Enum.reduce(sign, fn d, sum -> sum * d end)
  end
  def det(_), do: raise ArgumentError, "the matrix has to be represented as a nested NxN list"

  defp update_matrix(matrix, _, j, size) when size <= j, do: matrix
  defp update_matrix(matrix, i, j, size) do
      new_value = (matrix |> Enum.at(j) |> Enum.at(i)) / (matrix |> Enum.at(i) |> Enum.at(i))
      matrix = matrix |> update_element(j, i, new_value) |> update_for_u(i, j, i + 1, size)
      update_matrix(matrix, i, j + 1, size)
  end

  defp update_for_u(matrix, _, _, k, size) when size <= k, do: matrix
  defp update_for_u(matrix, i, j, k, size) do
    new_value = (matrix |> Enum.at(j) |> Enum.at(k)) - ((matrix |> Enum.at(j) |> Enum.at(i)) * (matrix |> Enum.at(i) |> Enum.at(k)))
    update_for_u(update_element(matrix, j, k, new_value), i, j, k + 1, size)
  end

  defp swap_elements(vector, i, j) when is_list(vector) and is_integer(i) and is_integer(j) do
    temp = vector |> Enum.at(i)
    vector
    |> List.replace_at(i, Enum.at(vector, j))
    |> List.replace_at(j, temp)
  end

  defp update_element(matrix, i, j, element) do
    new_row = matrix |> Enum.at(i) |> List.replace_at(j, element)
    matrix |> List.replace_at(i, new_row)
  end

  defp swap_nested_elements(list, {i1, j1}, {i2, j2}) when is_list(list) and is_integer(i1) and is_integer(j1) and is_integer(i2) and is_integer(j2) do
    temp = list |> Enum.at(i1) |> Enum.at(j1)
    row1 = list |> Enum.at(i1)
    row2 = list |> Enum.at(i2)
    new_row1 = row1 |> List.replace_at(j1, Enum.at(row2, j2))
    new_row2 = row2 |> List.replace_at(j2, temp)
    list |> List.replace_at(i1, new_row1) |> List.replace_at(i2, new_row2)
  end

  defp swap_raws(list, row1, row2) when is_list(list) and is_integer(row1) and is_integer(row2) do
    list
    |> List.replace_at(row1, list |> Enum.at(row2))
    |> List.replace_at(row2, list |> Enum.at(row1))
  end
end
