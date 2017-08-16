Code.require_file "../../lib/algebra/vector.ex", __DIR__

ExUnit.start()
defmodule Algebra.VectorTest do
  use ExUnit.Case, async: true

  alias Algebra.Vector


  describe "Vector.add_scalar/2" do
    test "returns the initial vector with added to each element the scalar" do
      assert Vector.add_scalar([1, 2, -3], 2) == [3, 4, -1]
    end

     test "raises error when the second argument is not a scalar" do
      assert_raise ArgumentError, fn -> Vector.add_scalar([1, 2], [1, 2]) end
      assert_raise ArgumentError, fn -> Vector.add_scalar([1, 2], {1}) end
      assert_raise ArgumentError, fn -> Vector.add_scalar([1, 2], %{n: 1}) end
    end

    test "raises error when first argument is not a vector" do
      assert_raise ArgumentError, fn -> Vector.add_scalar(1, 2) end
      assert_raise ArgumentError, fn -> Vector.add_scalar(%{}, 2) end
    end
  end

  describe "Vector.sub_scalar/2" do
    test "returns the initial vector with subtracted from each element the scalar" do
      assert Vector.sub_scalar([1, 2, -3], 2) == [-1, 0, -5]
    end
  end

  describe "Vector.multiply_scalar/2" do
    test "returns the initial vector with each element multiplied by the scalar" do
      assert Vector.multiply_scalar([1, 2, -3], 2) == [2, 4, -6]
    end
  end

  describe "Vector.add/2" do
    test "returns the sum by elements of the two vectors" do
      assert Vector.add([1, 2, 3], [4, 5, -6]) == [5, 7, -3]
    end

    test "raises error when the vectors are not with equal lengths" do
      assert_raise ArgumentError, fn -> Vector.add([1, 2], [2]) end
      assert_raise ArgumentError, fn -> Vector.add([2], [1, 2]) end
    end
  end

  describe "Vector.sub/2" do
    test "returns the difference between the two vectors" do
      assert Vector.sub([1, 2, 3], [4, 5, -6]) == [-3, -3, 9]
    end

    test "raises error when the vectors are not with equal lengths" do
      assert_raise ArgumentError, fn -> Vector.sub([1, 2], [2]) end
      assert_raise ArgumentError, fn -> Vector.sub([2], [1, 2]) end
    end
  end

   describe "Vector.div_element_wise/2" do
    test "returns the left vector with each element divided by the corresponding element from the right vector" do
      assert Vector.div_element_wise([1, 8, 3], [4, 4, -6]) == [0.25, 2, -0.5]
    end

    test "raises error when the vectors are not with equal lengths" do
      assert_raise ArgumentError, fn -> Vector.div_element_wise([1, 2], [2]) end
      assert_raise ArgumentError, fn -> Vector.div_element_wise([2], [1, 2]) end
    end
  end

  describe "Vector.hadamard_prod/2" do
    test "returns the Hadamard product between the two vectors" do
      assert Vector.hadamard_prod([1, 2, 3], [4, 5, -6]) == [4, 10, -18]
    end

    test "raises error when the vectors are not with equal lengths" do
      assert_raise ArgumentError, fn -> Vector.hadamard_prod([1, 2], [2]) end
      assert_raise ArgumentError, fn -> Vector.hadamard_prod([2], [1, 2]) end
    end
  end

  describe "Vector.dot_prod/2" do
    test "returns floating point when both vectors are lists" do
      assert Vector.dot_prod([1, -1, 3.4], [2.8, 3, -1]) == -3.6
    end

    test "returns floating point when both vectors are tuples" do
      assert Vector.dot_prod({1, -1, 3.4}, {2.8, 3, -1}) == -3.6
    end

    test "returns the correct result for n-dimentional vectors" do
      assert Vector.dot_prod({}, {}) == 0
      assert Vector.dot_prod([], []) == 0
      assert Vector.dot_prod([1], [2]) == 2
      assert Vector.dot_prod([1, -1, 3, 2], [2, 3, 1, 0]) == 2
      assert Vector.dot_prod([1, -1, 3, 2, 5], [2, 3, 1, 0, 5]) == 27
    end

    test "raises error when mixed types" do
      assert_raise ArgumentError, fn -> Vector.dot_prod([1, -1, 3.4], {2.8, 3, -1}) end
      assert_raise ArgumentError, fn -> Vector.dot_prod([1, -1, 3.4], 3.14) end
      assert_raise ArgumentError, fn -> Vector.dot_prod("bad argument", [2.8, 3, -1]) end
    end

    test "raises error when vectors are neither lists nor tuples" do
      assert_raise ArgumentError, fn -> Vector.dot_prod(%{x1: 1, y1: 2}, %{x2: 5, y2: 1}) end
      assert_raise ArgumentError, fn -> Vector.dot_prod(3.1415, 3.1415) end
      assert_raise ArgumentError, fn -> Vector.dot_prod("bad argument", "bad argument") end
    end
  end
end
