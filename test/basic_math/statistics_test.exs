Code.require_file "../../lib/basic_math/statistics.ex", __DIR__

ExUnit.start()
defmodule BasicMath.StatisticsTest do
  use ExUnit.Case, async: true

  alias BasicMath.Statistics

  describe "Statistics.euclidean_distance/2" do
    test "Euclidean distance with 0, 1, 2, ..., n dimensional vectors" do
      assert Statistics.euclidean_distance([], []) == 0
      assert Statistics.euclidean_distance([3], [1]) == 2
      assert Statistics.euclidean_distance([3, 0], [-1, -3]) == 5
      assert Statistics.euclidean_distance([3, 6, 8, 10], [1, 2, 3, 4]) == 9
    end
  end

  describe "Statistics.mean/1" do
    test "calculates the mean of an empty vector" do
      assert Statistics.mean([]) == 0
    end

    test "calculates the mean of a vector of data points" do
      assert Statistics.mean([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]) == 5.5
    end
  end

  describe "Statistics.median/1" do
    test "finds the middle point of a vector of data points when they are even number" do
      random_arr = Enum.shuffle([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])

      assert Statistics.median(random_arr) == 5.5
    end

    test "finds the middle point of a vector of data points when they are odd number" do
      random_arr = Enum.shuffle([1, 2, 3, 4, 5, 6, 7, 8, 9])

      assert Statistics.median(random_arr) == 5
    end
  end

  describe "Statistics.mode/1" do
    test "finds the first value when all of the values are equally common" do
      assert Statistics.mode([1, 2, 3, 4]) == 1
    end

    test "finds the most common value" do
      assert Statistics.mode([1, 2, 2, 3, 3, 3, 4, 5, 5]) == 3
    end
  end

  describe "Statistics.variance/1" do
    test "measures how spread out the values are" do
      assert Statistics.variance([1, 2, 3, 4, 1, 4, 5, 2, 2]) == 16
    end
  end

  describe "Statistics.standard_deviation/1" do
    test "measures how spread out the values are" do
      assert Statistics.standard_deviation([1, 2, 3, 4, 1, 4, 5, 2, 2]) == 4
    end
  end

  describe "Statistics.covariance/1" do
    test "measures how dependent two variable are" do
      assert Statistics.covariance([1.1, 1.7, 2.3, 1.4, 0.2], [3, 4.2, 4.9, 4.0, 2.5]) == 2.886
    end
  end

  describe "Statistics.rescaling/2" do
    test "returns rescaled values in range [0, 1]" do
      assert Statistics.rescaling([180, 160, 170, 200], [0, 1]) == [0.5, 0.0, 0.25, 1.0]
    end

    test "returns rescaled values in range [-1, 1]" do
      assert Statistics.rescaling([180, 160, 170, 200], [-1, 1]) == [0.0, -1.0, -0.5, 1.0]
    end

    test "raises error when the min and max value of the range are equal" do
      assert_raise ArgumentError, fn -> Statistics.rescaling([180, 180], [-1, 1]) end
    end
  end

  describe "Statistics.standardization/1" do
    test "returns standardized list of values" do
      eps = 0.0001

      [Statistics.standardization([5, 10, 15, 20]), [-0.6708, -0.2236, 0.2236, 0.6708]]
      |> Enum.zip
      |>  Enum.each(fn {real, expected} ->
            assert_in_delta real, expected, eps
          end)
    end

    test "raises error when the standard deviation is zero" do
      assert_raise ArgumentError, fn -> Statistics.standardization([10, 10, 10]) end
    end
  end
end
