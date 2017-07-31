Code.require_file "../lib/introduction.ex", __DIR__

ExUnit.start()
defmodule IntroductionTest do
  use ExUnit.Case, async: true

  setup do
    %{data: [{0, 0}, {0.52, 1.5}, {1.04, -2.59}, {1.57, 3.0}, {2.09, -2.59}, {2.61, 1.5}, {3.14, 0}]}
  end

  describe "Introduction.interpolation/1" do
    test "the accuracy of interpolation(x)", context do
      assert Introduction.interpolation(elem(hd(context.data), 0)) == elem(hd(context.data), 1)
    end
  end
end
