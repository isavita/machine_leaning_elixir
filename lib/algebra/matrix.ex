defmodule Algebra.Matrix do
  @moduledoc """
  Provides base matrix algebra operations.

  ## Examples

    iex> Algebra.Matrix.identity(3)
    [[1, 0, 0], [0, 1, 0], [0, 0, 1]]

    iex> Algebra.Matrix.zero(2, 3)
    [[0, 0, 0], [0, 0, 0]]

    iex> Algebra.Matrix.transpose([[1, 3, 5], [2, 4, 7]])
    [[1, 2], [3, 4], [5, 7]]

    iex> Algebra.Matrix.add([[2, 2], [-2, -2], [0, 0]], [[1, 2], [3, 4], [5, 6]])
    [[3, 4], [1, 2], [5, 6]]

    iex> Algebra.Matrix.multiply([[2, 4], [-2, -2]], [[1, 2], [3, 4]])
    [[14, 20], [-8, -12]]

    iex> Algebra.Matrix.lup_decomposition([[1, 3, 5], [2, 4, 7], [1, 1, 0]])
    {[[1, 0, 0], [0.5, 1, 0], [0.5, -1.0, 1]],
      [[2, 4, 7], [0, 1.0, 1.5], [0, 0, -2.0]],
      [[0, 1, 0], [1, 0, 0], [0, 0, 1]]}

    iex> Algebra.Matrix.det([[1, 2], [3, 4]])
    -2
  """

  @typedoc """
  List of nested lists.
  """
  @type matrix :: [list]

  @doc """
  Creates identity matrix with specified size.
  """
  @spec identity(integer) :: matrix
  def identity(size) when is_integer(size) and size > 0 do
    0..(size - 1)
    |> Enum.into([])
    |> Enum.map(fn pos -> List.duplicate(0, size - 1) |> List.insert_at(pos, 1) end)
  end
  def identity(_), do: raise ArgumentError, "the matrix's size has to be a positive integer"

  @doc """
  Creates zero matrix with specified row_size and column_size.
  """
  @spec zero(integer, integer) :: matrix
  def zero(row_size, column_size) when is_integer(row_size) and row_size > 0 and is_integer(column_size) and column_size > 0 do
    1..row_size
    |>  Enum.map(fn _ -> List.duplicate(0, column_size) end)
  end
  def zero(_, _), do: raise ArgumentError, "the matrix's size has to be a positive integer"

  @doc """
  Calculates the transposed matrix.
  """
  @spec transpose(matrix) :: matrix
  def transpose([[]]), do: [[]]
  def transpose([a]) when not is_list(a), do: raise ArgumentError, "the matrix has to be represented by a nested list"
  def transpose(a) when is_list(a), do: a |> Enum.zip |> Enum.map(&Tuple.to_list/1)
  def transpose(_), do: raise ArgumentError, "the matrix has to be represented by a nested list"

  @doc """
  Gets diagonal elements of matrix.
  """
  @spec diag(matrix) :: list
  def diag(matrix) do
    do_diag(matrix, 0)
  end

  defp do_diag([], _), do: []
  defp do_diag([h | _], j) when length(h) <= j , do: []
  defp do_diag([h | t], j) do
    [Enum.at(h, j) | do_diag(t, j + 1)]
  end

  @doc """
  Adds matrices with the same dimensionality.
  """
  @spec add(matrix, matrix) :: matrix
  def add(matrix_a, matrix_b), do: element_wise_op(matrix_a, matrix_b, &+/2)

  @doc """
  Subtracts matrices with the same dimensionality.
  """
  @spec sub(matrix, matrix) :: matrix
  def sub(matrix_a, matrix_b), do: element_wise_op(matrix_a, matrix_b, &-/2)

  @doc """
  Takes two matrices of the same dimensions, and produces another matrix where each element ij
  is the product of elements ij of the original two matrices.
  """
  @spec hadamard_prod(matrix, matrix) :: matrix
  def hadamard_prod(matrix_a, matrix_b), do: element_wise_op(matrix_a, matrix_b, &*/2)

  @doc """
  Takes two matrices of the same dimensions and produces another matrix by applying the
  function for the corresponding pair of element from each matrix.
  """
  @spec element_wise_fun(matrix, matrix, fun) :: matrix
  def element_wise_fun(matrix_a, matrix_b, fun), do: element_wise_op(matrix_a, matrix_b, fun)

  @doc """
  Multiplies two matrices when the columns of the first one are equal to the rows of the second one.
  """
  @spec multiply(matrix, matrix) :: matrix
  def multiply([h | _], matrix_b) when length(h) != length(matrix_b) do
    raise ArgumentError, "the second matrix has to have rows equal to the columns of the first matrix"
  end
  # OPTIMIZE: Spawn a process for calculating each row of the new matrix.
  def multiply(matrix_a, matrix_b) do
    transposed_b = transpose(matrix_b)
    matrix_a
    |>  Enum.map(fn row_a ->
          transposed_b |> Enum.map(fn row_b ->
            Enum.zip(row_a, row_b)
            |> Enum.map(fn {ai, b} -> ai * b end)
            |> Enum.sum
          end)
        end)
  end

  # TODO: Reuse the logic from multiply if possible.
  @doc """
  Multiplies the matrix by a row vector.
  """
  @spec multiply_row_vector(list, matrix) :: matrix
  def multiply_row_vector(vector, matrix) when length(vector) != length(matrix) do
    raise ArgumentError, "the matrix has to have rows equal to the length of the vector"
  end
  def multiply_row_vector(vector, matrix) do
    matrix
    |> transpose()
    |>  Enum.map(fn row ->
          Enum.zip(vector, row)
          |> Enum.map(fn {vi, mi} -> vi * mi end)
          |> Enum.sum
        end)
  end

  @doc """
  Multiplies the matrix by a row vector.
  """
  @spec multiply_column_vector(matrix, list) :: matrix
  def multiply_column_vector([row | _], vector) when length(row) != length(vector) do
    raise ArgumentError, "the matrix has to have columns equal to the length of the vector"
  end
  def multiply_column_vector(matrix, vector) do
    multiply(matrix, transpose([vector]))
  end

  @doc """
  Creates a new matrix from original one using the `columns` indexes list to
  determen which columns to copy from the original matrix.
  """
  @spec extract_columns(matrix, list) :: matrix
  def extract_columns(matrix, columns) when is_list(matrix) and is_list(columns) do
    matrix
    |> transpose()
    |> extract_rows(columns)
    |> transpose()
  end
  def extract_columns(_, _), do: raise ArgumentError, "the matrix and column indexes have to be lists"

  @doc """
  Creates a new matrix from original one using the `rows` indexes list to
  determen which rows to copy from the original matrix.
  """
  @spec extract_rows(matrix, list) :: matrix
  def extract_rows(matrix, rows) when is_list(matrix) and is_list(rows) do
    matrix
    |> Enum.with_index
    |> Enum.filter(fn {_, index} -> index in rows end)
    |> Enum.map(fn {value, _} -> value end)
  end
  def extract_rows(_, _), do: raise ArgumentError, "the matrix and row indexes have to be lists"

  @doc """
  Applies the operation to each row element the corresponding vector element.
  """
  @spec row_wise_operation(matrix, list, fun) :: matrix
  def row_wise_operation([row | _], vector, _) when length(row) != length(vector) do
    raise ArgumentError, "the matrix's rows have to have the same length as the vector"
  end
  def row_wise_operation(matrix, vector, operation) do
    matrix |> Enum.map(fn row -> element_wise_op([row], [vector], operation) |> Enum.at(0) end)
  end

  @doc """
  Applies the operation to each column element the corresponding vector element.
  """
  @spec column_wise_operation(matrix, list, fun) :: matrix
  def column_wise_operation(matrix, vector, _) when length(matrix) != length(vector) do
    raise ArgumentError, "the matrix's columns have to have the same length as the vector"
  end
  def column_wise_operation(matrix, vector, operation) do
    row_wise_operation(transpose(matrix), vector, operation) |> transpose
  end

  @doc """
  Applies the operation to each element of the matrix and the scalar.
  """
  @spec scalar_element_wise_operation(matrix, number, fun) :: matrix
  def scalar_element_wise_operation(matrix, scalar, operation) do
    curried_operation = fn x -> operation.(scalar, x) end
    element_wise_fun(matrix, curried_operation)
  end

  @doc """
  Applies the function to each element of the matrix.
  """
  @spec element_wise_fun(matrix, fun) :: matrix
  def element_wise_fun(matrix, fun) do
    matrix |> Enum.map(fn row -> Enum.map(row, &fun.(&1)) end)
  end

  # HACK: try to use lup_decompostion result instead of do_lup_decompostion.
  @doc """
  Calculates the determinant of square matrix using LUP decomposition.
  """
  @spec det(matrix) :: float
  def det([[]]), do: 0
  def det([[n]]) when is_number(n), do: n
  def det([h | _] = matrix) when length(h) == length(matrix) do
    size = length(matrix)
    p_vector = 0..size |> Enum.into([])
    {dec_matrix, p_vector} = do_lup_decomposition(matrix, p_vector, size, 0)
    sign = :math.pow(-1, Enum.at(p_vector, -1) - size)
    dec_matrix
    |> diag()
    |> Enum.reduce(sign, fn d, sum -> sum * d end)
  end
  def det(_), do: raise ArgumentError, "the matrix has to be represented as a nested NxN list"

  @doc """
  Inverses a given square matrix with no zero determinant.
  """
  @spec inverse(matrix) :: matrix
  def inverse([h | _] = matrix) when length(h) != length(matrix) do
    raise ArgumentError, "the matrix has to be represented as a nested NxN list"
  end
  def inverse(matrix) do
    size = length(matrix)
    p_vector = 0..size |> Enum.into([])
    {dec_matrix, p_vector} = do_lup_decomposition(matrix, p_vector, size, 0)
    invert_matrix = calc_p_from_p_vector(p_vector)
    do_inverse(dec_matrix, invert_matrix, 0, size)
  end

  @spec do_inverse(matrix, matrix, integer, integer) :: matrix
  defp do_inverse(_, invert_matrix, j, size) when j >= size, do: invert_matrix
  defp do_inverse(matrix, invert_matrix, j, size) do
    invert_matrix = pre_calc_row_inverst(matrix, invert_matrix, 0, j, size)
    invert_matrix = calc_row_inverst(matrix, invert_matrix, size - 1, j, size)
    do_inverse(matrix, invert_matrix, j + 1, size)
  end

  # TODO: give a better name of the function.
  @spec pre_calc_row_inverst(matrix, matrix, integer, integer, integer) :: matrix
  defp pre_calc_row_inverst(_, invert_matrix, i, _, size) when i >= size, do: invert_matrix
  defp pre_calc_row_inverst(matrix, invert_matrix, i, j, size) do
    invert_matrix =
      cond do
        i > 0 ->
          new_elem =
            0..(i - 1)
            |> Enum.map(fn k -> get_value(matrix, i, k) * get_value(invert_matrix, k, j) end)
            |> Enum.sum

          update_element(invert_matrix, i, j, get_value(invert_matrix, i, j) - new_elem)
        true -> invert_matrix
      end

    pre_calc_row_inverst(matrix, invert_matrix, i + 1, j, size)
  end

  @spec calc_row_inverst(matrix, matrix, integer, integer, integer) :: matrix
  defp calc_row_inverst(_, invert_matrix, i, _, _) when i <= -1, do: invert_matrix
  defp calc_row_inverst(matrix, invert_matrix, i, j, size) do
    invert_matrix =
      cond do
        (i + 1 <= size - 1) ->
          new_elem =
            (i + 1)..(size - 1)
            |> Enum.map(fn k -> get_value(matrix, i, k) * get_value(invert_matrix, k, j) end)
            |> Enum.sum

          new_elem = (get_value(invert_matrix, i, j) - new_elem) / get_value(matrix, i, i)

          update_element(invert_matrix, i, j, new_elem)
        true ->
          invert_matrix
        end

    calc_row_inverst(matrix, invert_matrix, i - 1, j, size)
  end

  @doc """
  Calculates the LUP decomposition of square matrix.
  The permutation matrix is stored as a vector of integer containing
  column indexes where the permutation matrix has "1".
  """
  @spec lup_decomposition(matrix) :: {matrix, matrix, matrix}
  def lup_decomposition([h | _] = matrix) when length(h) != length(matrix) do
    raise ArgumentError, "the matrix has to be square"
  end
  def lup_decomposition(matrix) do
    size = length(matrix)
    p_vector = 0..size |> Enum.into([])
    {_, p_vector} = do_lup_decomposition(matrix, p_vector, size, 0)
    p = calc_p_from_p_vector(p_vector)
    permuted_matrix = multiply(p, matrix)
    l = identity(size)
    u = zero(size, size)
    {l, u} = calc_lu_from_permuted_matrix(permuted_matrix, l, u, 0, 0, size)
    {l, u, p}
  end

  @spec do_lup_decomposition(matrix, list, integer, integer) :: {matrix, list}
  defp do_lup_decomposition(matrix, p_vector, size, i) when size <= i, do: {matrix, p_vector}
  defp do_lup_decomposition(matrix, p_vector, size, i) do
    max_index =
      matrix
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

  # HACK: try to simplify if possible.
  @spec calc_lu_from_permuted_matrix(matrix, integer, integer, integer, integer, integer) :: {integer, integer}
  defp calc_lu_from_permuted_matrix(_, l, u, i, _, size) when size <= i, do: {l, u}
  defp calc_lu_from_permuted_matrix(matrix, l, u, i, j, size) when size <= j, do: calc_lu_from_permuted_matrix(matrix, l, u, i + 1, 0, size)
  defp calc_lu_from_permuted_matrix(matrix, l, u, i, j, size) do
    {l, u} =
      cond do
        i <= j ->
          u_elem = get_value(matrix, i, j) - Enum.reduce(0..(i - 1), 0, fn k, sum -> sum + get_value(u, k, j) * get_value(l, i, k) end)
          u = update_element(u, i, j, u_elem)
          {l, u}
        true ->
          l_elem = get_value(matrix, i, j) - Enum.reduce(0..(j - 1), 0, fn k, sum -> sum + get_value(u, k, j) * get_value(l, i, k) end)
          l_elem = l_elem / get_value(u, j, j)
          l = update_element(l, i, j, l_elem)
          {l, u}
      end
    calc_lu_from_permuted_matrix(matrix, l, u, i, j + 1, size)
  end

  # The p_vector contains column indexes where permutation matrix P has "1" and
  # as a last element the size of the matrix A plus the number of permutations done
  # during LUP decomposition.
  @spec calc_p_from_p_vector(list) :: list
  defp calc_p_from_p_vector(p_vector) do
    size = length(p_vector) - 2 # the matrix's indexes start from 0
    p_vector
    |> Enum.drop(-1)
    |> Enum.map(fn pos -> List.duplicate(0, size) |> List.insert_at(pos, 1) end)
  end

  @spec update_matrix(matrix, integer, integer, integer) :: matrix
  defp update_matrix(matrix, _, j, size) when size <= j, do: matrix
  defp update_matrix(matrix, i, j, size) do
      new_value = (matrix |> Enum.at(j) |> Enum.at(i)) / (matrix |> Enum.at(i) |> Enum.at(i))
      matrix = matrix |> update_element(j, i, new_value) |> update_for_u(i, j, i + 1, size)
      update_matrix(matrix, i, j + 1, size)
  end

  @spec update_for_u(matrix, integer, integer, integer, integer) :: matrix
  defp update_for_u(matrix, _, _, k, size) when size <= k, do: matrix
  defp update_for_u(matrix, i, j, k, size) do
    new_value = (matrix |> Enum.at(j) |> Enum.at(k)) - ((matrix |> Enum.at(j) |> Enum.at(i)) * (matrix |> Enum.at(i) |> Enum.at(k)))
    update_for_u(update_element(matrix, j, k, new_value), i, j, k + 1, size)
  end

  @spec get_value(matrix, integer, integer) :: any
  defp get_value(matrix, i, j) do
    matrix |> Enum.at(i) |> Enum.at(j)
  end

  @spec update_element(matrix, integer, integer, any) :: any
  defp update_element(matrix, i, j, element) do
    new_row = matrix |> Enum.at(i) |> List.replace_at(j, element)
    matrix |> List.replace_at(i, new_row)
  end

  @spec swap_elements(list, integer, integer) :: list
  defp swap_elements(vector, i, j) when is_list(vector) and is_integer(i) and is_integer(j) do
    temp = vector |> Enum.at(i)
    vector
    |> List.replace_at(i, Enum.at(vector, j))
    |> List.replace_at(j, temp)
  end

  @spec swap_raws(matrix, list, list) :: matrix
  defp swap_raws(matrix, row1, row2) when is_list(matrix) and is_integer(row1) and is_integer(row2) do
    matrix
    |> List.replace_at(row1, matrix |> Enum.at(row2))
    |> List.replace_at(row2, matrix |> Enum.at(row1))
  end

  @spec element_wise_op(matrix, matrix, fun) :: matrix
  defp element_wise_op([ha | _] = ma, [hb | _] = mb, _) when length(ma) != length(mb) or length(ha) != length(hb) do
    raise ArgumentError, "the matrices have to have the same dimensions"
  end
  defp element_wise_op(matrix_a, matrix_b, operation) do
    Enum.zip(matrix_a, matrix_b)
    |> Enum.map(fn {row_a, row_b} -> Enum.zip(row_a, row_b) |> Enum.map(fn {a, b} -> operation.(a, b) end) end)
  end
end
