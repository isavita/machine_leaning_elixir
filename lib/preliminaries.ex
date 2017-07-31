defmodule Preliminaries do
  def distance(xs, ys) when length(xs) == length(ys) do
    Enum.zip(xs, ys)
    |> Enum.map(fn x -> :math.pow(elem(x, 1) - elem(x, 0), 2) end)
    |> Enum.sum
    |> :math.sqrt
  end

  def unit_hypersphere_volume(1), do: 2.0
  def unit_hypersphere_volume(2), do: :math.pi
  def unit_hypersphere_volume(n) when n > 2 do
    ((2 * :math.pi) / n) * unit_hypersphere_volume(n - 2)
  end

  def mean([]), do: 0
  def mean(xs), do: xs |> Enum.sum |> Kernel./(length(xs))

  def median(xs) when rem(length(xs), 2) != 0, do: Enum.sort(xs) |> Enum.at(div(length(xs), 2))
  def median(xs) do
    xs = Enum.sort(xs)
    len = length(xs)
    (Enum.at(xs, div(len, 2) - 1) + Enum.at(xs, div(len, 2))) / 2
  end

  def mode(xs), do: xs |> Enum.group_by(&(&1)) |> Map.values |> Enum.max_by(&length/1) |> Enum.at(0)

  def variance([]), do: 0
  def variance(xs) do
    mu = mean(xs)
    xs |> Enum.map(&(:math.pow(&1 - mu, 2))) |> Enum.sum
  end

  def standard_deviation(xs), do: variance(xs) |> :math.sqrt

  def covariance([], _), do: 0
  def covariance(_, []), do: 0
  def covariance(xs, ys) do
    {mu, nu} = {mean(xs), mean(ys)}
    Enum.zip(xs, ys) |> Enum.reduce(0, fn {x, y}, prod -> prod + (x - mu) * (y - nu) end)
  end

  def normal_distribution_d1(_, _, 0), do: nil
  def normal_distribution_d1(x, mu, sd) do
    :math.exp(-:math.pow(x - mu, 2) / (2 * sd * sd))/ (:math.sqrt(2 * :math.pi) * sd)
  end
end
