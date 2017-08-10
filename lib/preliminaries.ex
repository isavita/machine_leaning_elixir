defmodule Preliminaries do
  def unit_hypersphere_volume(1), do: 2.0
  def unit_hypersphere_volume(2), do: :math.pi
  def unit_hypersphere_volume(n) when n > 2 do
    ((2 * :math.pi) / n) * unit_hypersphere_volume(n - 2)
  end

  def normal_distribution_d1(_, _, 0), do: nil
  def normal_distribution_d1(x, mu, sd) do
    :math.exp(-:math.pow(x - mu, 2) / (2 * sd * sd))/ (:math.sqrt(2 * :math.pi) * sd)
  end
end
