Code.require_file "../../lib/algebra/matrix.ex", __DIR__

ExUnit.start()
defmodule Algebra.MatrixTest do
  use ExUnit.Case, async: true

  alias Algebra.Matrix

  describe "Matrix.identity/1" do
    test "returns 1-D, 2-D, ..., n-D identity matrix" do
      assert Matrix.identity(1) == [[1]]
      assert Matrix.identity(2) == [[1, 0], [0, 1]]
      assert Matrix.identity(3) == [[1, 0, 0], [0, 1, 0], [0, 0, 1]]
      assert Matrix.identity(4) == [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]]
      assert Matrix.identity(5) == [[1, 0, 0, 0, 0], [0, 1, 0, 0, 0], [0, 0, 1, 0, 0], [0, 0, 0, 1, 0], [0, 0, 0, 0, 1]]
    end

    test "raises error when the argument is not a positive integer" do
      assert_raise ArgumentError, fn -> Matrix.identity(0) end
      assert_raise ArgumentError, fn -> Matrix.identity(2.7) end
      assert_raise ArgumentError, fn -> Matrix.identity(-3) end
      assert_raise ArgumentError, fn -> Matrix.identity("bad argument") end
      assert_raise ArgumentError, fn -> Matrix.identity([1]) end
      assert_raise ArgumentError, fn -> Matrix.identity({1}) end
      assert_raise ArgumentError, fn -> Matrix.identity(%{a: 3.1415}) end
    end
  end

  describe "Matrix.zero/1" do
    test "returns 1-D, 2-D, ..., n-D identity matrix" do
      assert Matrix.zero(1, 1) == [[0]]
      assert Matrix.zero(2, 1) == [[0], [0]]
      assert Matrix.zero(3, 3) == [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
      assert Matrix.zero(4, 5) == [[0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]]
      assert Matrix.zero(5, 4) == [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
    end

    test "raises error when the argument is not a positive integer" do
      assert_raise ArgumentError, fn -> Matrix.zero(0, 2) end
      assert_raise ArgumentError, fn -> Matrix.zero(1, 2.7) end
      assert_raise ArgumentError, fn -> Matrix.zero(-3, %{}) end
      assert_raise ArgumentError, fn -> Matrix.zero(6, "bad argument") end
    end
  end

  describe "Matrix.transpose/1" do
    test "returns the transposed matrix of the original" do
      assert Matrix.transpose([[]]) == [[]]
      assert Matrix.transpose([[1]]) == [[1]]
      assert Matrix.transpose([[1, 3, 5], [2, 4, 7]]) == [[1, 2], [3, 4], [5, 7]]
    end

    test "raises error when the argument is not a 2-D list" do
      assert_raise ArgumentError, fn -> Matrix.transpose([1]) end
      assert_raise ArgumentError, fn -> Matrix.transpose(3.1415) end
      assert_raise ArgumentError, fn -> Matrix.transpose("bad argument") end
      assert_raise ArgumentError, fn -> Matrix.transpose({2.71}) end
      assert_raise ArgumentError, fn -> Matrix.transpose(%{}) end
    end
  end

  describe "Matrix.diag/1" do
    test "returns vector with the matrix diagonal" do
      assert Matrix.diag([[1, 2], [3, 4]]) == [1, 4]
      assert Matrix.diag([[1, 2, 3], [4, 5, 6]]) == [1, 5]
      assert Matrix.diag([[1, 2], [3, 4], [5, 6]]) == [1, 4]
    end
  end

  describe "Matrix.add/2" do
    test "adds the two matrices when they are with the same dimensions" do
      assert Matrix.add([[2, 2], [-2, -2]], [[1, 2], [3, 4]]) == [[3, 4], [1, 2]]
      assert Matrix.add([[2, 2], [-2, -2], [0, 0]], [[1, 2], [3, 4], [5, 6]]) == [[3, 4], [1, 2], [5, 6]]
    end

    test "raises error when the matrices are with different dimensions" do
      assert_raise ArgumentError, fn -> Matrix.add([[1, 2], [3, 4]], [[1, 2], [3, 4], [5, 6]]) end
      assert_raise ArgumentError, fn -> Matrix.add([[1, 2], [3, 4]], [[1, 2, 3], [4, 5, 6]]) end
    end
  end

  describe "Matrix.sub/2" do
    test "subtracts second matrix form the first one when they are with the same dimensions" do
      assert Matrix.sub([[2, 2], [-2, -2]], [[1, 2], [3, 4]]) == [[1, 0], [-5, -6]]
      assert Matrix.sub([[2, 2], [-2, -2], [0, 0]], [[1, 2], [3, 4], [5, 6]]) == [[1, 0], [-5, -6], [-5, -6]]
    end

    test "raises error when the matrices are with different dimensions" do
      assert_raise ArgumentError, fn -> Matrix.sub([[1, 2], [3, 4]], [[1, 2], [3, 4], [5, 6]]) end
      assert_raise ArgumentError, fn -> Matrix.sub([[1, 2], [3, 4]], [[1, 2, 3], [4, 5, 6]]) end
    end
  end

  describe "Matrix.multiply/2" do
    test "multiply square matrices" do
      assert Matrix.multiply([[2, 2], [-2, -2]], [[1, 2], [3, 4]]) == [[8, 12], [-8, -12]]
    end

    test "multiply a MxN matrix with NxK matrix" do
      assert Matrix.multiply([[2, 2], [-2, -2]], [[1, 2, 3], [4, 5, 6]]) == [[10, 14, 18], [-10, -14, -18]]
    end

    test "raises error when the matrices cannot be multiply" do
      assert_raise ArgumentError, fn -> Matrix.multiply([[1, 2], [3, 4]], [[1, 2], [3, 4], [5, 6]]) end
    end
  end

  describe "Matrix.multiply_row_vector/2" do
    test "returns a row vector when multiplied by a row vector from the left-hand side" do
      assert Matrix.multiply_row_vector([1, 2, 3], [[1, 2], [3, 4], [5, 6]]) == [22, 28]
    end

    test "raises error when the multiplication is not defined" do
      assert_raise ArgumentError, fn -> Matrix.multiply_row_vector([1, 2], [[1, 2], [3, 4], [5, 6]]) end
    end
  end

  describe "Matrix.multiply_column_vector/2" do
    test "returns a single 'column' matrix when multiplied by a 'column' vector from the right-hand side" do
      assert Matrix.multiply_column_vector([[1, 2, 3], [4, 5, 6]], [1, 2, 3]) == [[14], [32]]
    end

    test "raises error when the multiplication is not defined" do
      assert_raise ArgumentError, fn -> Matrix.multiply_column_vector([[1, 2], [3, 4], [5, 6]], [1, 2, 3]) end
    end
  end

  describe "Matrix.extract_columns/2" do
    test "creates a new matrix from the original with columns given as list of indexes" do
      matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

      assert Matrix.extract_columns(matrix, [1, 2]) == [[2, 3], [5, 6], [8, 9]]
    end

    test "raises error when the columns are not represented as a list" do
      assert_raise ArgumentError, fn -> Matrix.extract_rows([[1, 2]], 0) end
      assert_raise ArgumentError, fn -> Matrix.extract_rows([[1, 2]], {0, 1}) end
    end
  end

  describe "Matrix.extract_rows/2" do
    test "creates a new matrix from the original with rows given as list of indexes" do
      matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

      assert Matrix.extract_rows(matrix, [1, 2]) == [[4, 5, 6], [7, 8, 9]]
    end

    test "raises error when the rows are not represented as a list" do
      assert_raise ArgumentError, fn -> Matrix.extract_rows([[1], [2]], 0) end
      assert_raise ArgumentError, fn -> Matrix.extract_rows([[1], [2]], {0, 1}) end
    end
  end

  describe "Matrix.lup_decomposition/1" do
    test "returns a tuple with an unit lower triangular, upper triangular, and unit permutation matrices" do
      matrix = [[1, 3, 5], [2, 4, 7], [1, 1, 0]]
      l = [[1, 0, 0], [0.5, 1, 0], [0.5, -1, 1]]
      u = [[2, 4, 7], [0, 1, 1.5], [0, 0, -2]]
      p = [[0, 1, 0], [1, 0, 0], [0, 0, 1]]

      assert Matrix.lup_decomposition(matrix) == {l, u, p}
    end

    test "raises error when the matrix is not square" do
      assert_raise ArgumentError, fn -> Matrix.lup_decomposition([[1, 2], [3, 4], [5, 6]]) end
    end
  end

  describe "Matrix.det/1" do
    test "returns the determinant of a 0-D square matrix" do
      assert Matrix.det([[]]) == 0
    end

    test "returns the determinant of a 1-D square matrix" do
      assert Matrix.det([[3.1415]]) == 3.1415
    end

    test "returns the determinant of a 2-D square matrix" do
      eps = 0.0001

      assert abs(Matrix.det([[1, 2], [3, 4]]) - (-2)) < eps
    end

    test "returns the determinant of a 3-D square matrix" do
      eps = 0.0001

      assert abs(Matrix.det([[1, 2, 3], [0, -4, 4], [3, 3, -1]]) - 52) < eps
    end

    test "returns the determinant of a 4-D square matrix" do
      eps = 0.0001

      assert abs(Matrix.det([[1, 2, 3, 1], [0, -4, 4, -11], [5, 3, 3, -1], [6, 5, 1, -2]]) - (-417)) < eps
    end

    test "raises error when the matrix is 1-D empty array" do
      assert_raise ArgumentError, fn -> Matrix.det([]) end
    end

    test "raises error when the matrix is not square" do
      assert_raise ArgumentError, fn -> Matrix.det([1, 2]) end
      assert_raise ArgumentError, fn -> Matrix.det([[1, 2], [3, 4], [5, 6]]) end
      assert_raise ArgumentError, fn -> Matrix.det([[1, 2, 3], [4, 5, 6]]) end
    end

    test "raises error when the matrix is not represented as a list" do
      assert_raise ArgumentError, fn -> Matrix.det([a: 2.7182]) end
      assert_raise ArgumentError, fn -> Matrix.det({1}) end
      assert_raise ArgumentError, fn -> Matrix.det(%{x1: 1, y1: 2}) end
      assert_raise ArgumentError, fn -> Matrix.det(3.1415) end
      assert_raise ArgumentError, fn -> Matrix.det("bad argument") end
    end
  end

  describe "Matrix.inverse/1" do
    test "returns the inverse matrix of a given matrix when exists" do
      matrix = [[-3, -2, -3], [5, 3, 3], [2, 1, 1]]
      expected_invert = [[0, -1, 3], [1, 3, -6], [-1, -1, 1]]  |> List.flatten
      invert = Matrix.inverse(matrix) |> List.flatten
      eps = 0.0001

      [invert, expected_invert]
      |> Enum.zip
      |> Enum.each(fn {a, b} ->
        assert_in_delta a, b, eps
      end)
    end

    test "raises error when the matrix is not square" do
      assert_raise ArgumentError, fn -> Matrix.inverse([[1, 2]]) end
    end
  end
end
