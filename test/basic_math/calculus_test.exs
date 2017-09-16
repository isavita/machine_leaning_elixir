Code.require_file "../../lib/basic_math/calculus.ex", __DIR__

ExUnit.start()
defmodule BasicMath.CalculusTest do
  use ExUnit.Case, async: true

  alias BasicMath.Calculus

  @epsilon_precision 0.00001

  describe "Calculus.sigmoid/1" do
    test "returns the correct values of sigmoid for the given arguments" do
      assert_in_delta Calculus.sigmoid(-20), 0, @epsilon_precision
      assert Calculus.sigmoid(0) == 0.5
      assert_in_delta Calculus.sigmoid(20), 1, @epsilon_precision
    end
  end

  describe "Calculus.sigmoid_derivative/1" do
    test "returns the correct values of sigmoid for the given arguments" do
      assert_in_delta Calculus.sigmoid_derivative(-20), 0, @epsilon_precision
      assert Calculus.sigmoid_derivative(0) == 0.25
      assert_in_delta Calculus.sigmoid_derivative(20), 0, @epsilon_precision
    end
  end

  describe "Calculus.softmax/1" do
    test "returns the correct values of softmax for the given arguments" do

    end
  end
end
