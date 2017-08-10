Code.require_file "../lib/preliminaries.ex", __DIR__

ExUnit.start
defmodule PreliminariesTest do
  use ExUnit.Case, async: true

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

  describe "Preliminaries.normal_distribution_d1" do
    test "calculates one dimensional Gaussian distribution" do
      eps = 0.001
      assert abs(Preliminaries.normal_distribution_d1(25, 23, 6.6) - 0.0577) < eps
    end
  end
end
