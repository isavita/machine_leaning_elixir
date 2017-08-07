Code.require_file "../lib/preliminaries.ex", __DIR__

ExUnit.start
defmodule PreliminariesTest do
  use ExUnit.Case, async: true

  describe "Preliminaries.distance/2" do
    test "Euclidean distance with 0, 1, 2, ..., n dimensional vectors" do
      assert Preliminaries.distance([], []) == 0
      assert Preliminaries.distance([3], [1]) == 2
      assert Preliminaries.distance([3, 0], [-1, -3]) == 5
      assert Preliminaries.distance([3, 6, 8, 10], [1, 2, 3, 4]) == 9
    end
  end

  describe "Preliminaries.unit_hypersphere_volume/1" do
    test "volume of unit hypersphere" do
      eps = 0.001

      assert Preliminaries.unit_hypersphere_volume(1) == 2
      assert Preliminaries.unit_hypersphere_volume(2) == :math.pi
      assert abs(Preliminaries.unit_hypersphere_volume(3) - 4.1888) < eps
      assert abs(Preliminaries.unit_hypersphere_volume(4) - 4.9348) < eps
      assert abs(Preliminaries.unit_hypersphere_volume(5) - 5.2636) < eps
      assert abs(Preliminaries.unit_hypersphere_volume(6) - 5.1677) < eps
    end

    test "volume of unit hypersphere is shrinking in higher than 5-th dimension" do
      assert Preliminaries.unit_hypersphere_volume(5) > Preliminaries.unit_hypersphere_volume(6)
      assert Preliminaries.unit_hypersphere_volume(6) > Preliminaries.unit_hypersphere_volume(7)
      assert Preliminaries.unit_hypersphere_volume(7) > Preliminaries.unit_hypersphere_volume(8)
    end
  end

  describe "Preliminaries.mean/1" do
    test "calculates the mean of an empty vector" do
      assert Preliminaries.mean([]) == 0
    end

    test "calculates the mean of a vector of data points" do
      assert Preliminaries.mean([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]) == 5.5
    end
  end

  describe "Preliminaries.median/1" do
    test "finds the middle point of a vector of data points when they are even number" do
      random_arr = Enum.shuffle([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])

      assert Preliminaries.median(random_arr) == 5.5
    end

    test "finds the middle point of a vector of data points when they are odd number" do
      random_arr = Enum.shuffle([1, 2, 3, 4, 5, 6, 7, 8, 9])

      assert Preliminaries.median(random_arr) == 5
    end
  end

  describe "Preliminaries.mode/1" do
    test "finds the first value when all of the values are equally common" do
      assert Preliminaries.mode([1, 2, 3, 4]) == 1
    end

    test "finds the most common value" do
      assert Preliminaries.mode([1, 2, 2, 3, 3, 3, 4, 5, 5]) == 3
    end
  end

  describe "Preliminaries.variance/1" do
    test "measures how spread out the values are" do
      assert Preliminaries.variance([1, 2, 3, 4, 1, 4, 5, 2, 2]) == 16
    end
  end

  describe "Preliminaries.standard_deviation/1" do
    test "measures how spread out the values are" do
      assert Preliminaries.standard_deviation([1, 2, 3, 4, 1, 4, 5, 2, 2]) == 4
    end
  end

  describe "Preliminaries.covariance/1" do
    test "measures how dependent two variable are" do
      assert Preliminaries.covariance([1.1, 1.7, 2.3, 1.4, 0.2], [3, 4.2, 4.9, 4.0, 2.5]) == 2.886
    end
  end

  describe "Preliminaries.normal_distribution_d1" do
    test "calculates one dimensional Gaussian distribution" do
      eps = 0.001
      assert abs(Preliminaries.normal_distribution_d1(25, 23, 6.6) - 0.0577) < eps
    end
  end
end
