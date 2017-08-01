Code.require_file "../../lib/algebra/vector.ex", __DIR__

ExUnit.start()
defmodule Algebra.VectorTest do
  use ExUnit.Case, async: true

  alias Algebra.Vector

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

    test "raise error when mixed types" do
      assert_raise ArgumentError, fn -> Vector.dot_prod([1, -1, 3.4], {2.8, 3, -1}) end
      assert_raise ArgumentError, fn -> Vector.dot_prod([1, -1, 3.4], 3.14) end
      assert_raise ArgumentError, fn -> Vector.dot_prod("bad argument", [2.8, 3, -1]) end
    end

    test "raise error when vectors are neither lists nor tuples" do
      assert_raise ArgumentError, fn -> Vector.dot_prod(%{x1: 1, y1: 2}, %{x2: 5, y2: 1}) end
      assert_raise ArgumentError, fn -> Vector.dot_prod(3.1415, 3.1415) end
      assert_raise ArgumentError, fn -> Vector.dot_prod("bad argument", "bad argument") end
    end
  end
end
