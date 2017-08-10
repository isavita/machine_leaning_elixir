defmodule BasicMath.Statistics do
  @moduledoc """
  Provides basic statistical functions.

  ### Examples

    iex> Statistics.euclidean_distance([3, 6, 8, 10], [1, 2, 3, 4])
    9.0

    iex> Statistics.mean([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    5.5

    iex> Statistics.mode([1, 2, 2, 3, 3, 3, 4, 5, 5])
    3

    iex> Statistics.standard_deviation([1, 2, 3, 4, 1, 4, 5, 2, 2])
    4.0
  """

  @doc """
  Calculates the Euclidean distance between two list of points.
  """
  def euclidean_distance(xs, ys) when length(xs) == length(ys) do
    Enum.zip(xs, ys)
    |> Enum.map(fn x -> :math.pow(elem(x, 1) - elem(x, 0), 2) end)
    |> Enum.sum
    |> :math.sqrt
  end

  @doc """
  Calculates the sum of a list of numbers, divided by the number of elements in the list.
  It is also known as `Average`.
  """
  def mean([]), do: 0
  def mean(xs), do: xs |> Enum.sum |> Kernel./(length(xs))

  @doc """
  Finds the `middle value` of a list. The smallest number such that at least half the numbers
  in the list are no greater than it.
  """
  def median(xs) when rem(length(xs), 2) != 0, do: Enum.sort(xs) |> Enum.at(div(length(xs), 2))
  def median(xs) do
    xs = Enum.sort(xs)
    len = length(xs)
    (Enum.at(xs, div(len, 2) - 1) + Enum.at(xs, div(len, 2))) / 2
  end

  @doc """
  Finds the most common (frequent) value in a list.
  """
  def mode(xs), do: xs |> Enum.group_by(&(&1)) |> Map.values |> Enum.max_by(&length/1) |> Enum.at(0)

  @doc """
  Calculates how much the numbers of a list differ from the mean value for the list.
  """
  def standard_deviation(xs), do: variance(xs) |> :math.sqrt

  @doc """
  Calculates the square of the standard deviation.
  """
  def variance([]), do: 0
  def variance(xs) do
    mu = mean(xs)
    xs |> Enum.map(&(:math.pow(&1 - mu, 2))) |> Enum.sum
  end

  @doc """
  Calculates the joint variability of two list of numbers.
  If the greater values of one variable mainly correspond with the greater values
  of the other variable, and the same holds for the lesser values, the covariance is positive.
  In the opposite case the covariance is negative.
  """
  def covariance([], _), do: 0
  def covariance(_, []), do: 0
  def covariance(xs, ys) do
    {mu, nu} = {mean(xs), mean(ys)}
    Enum.zip(xs, ys) |> Enum.reduce(0, fn {x, y}, prod -> prod + (x - mu) * (y - nu) end)
  end

  @doc """
  Rescales the list of number to scale the range in [a, b].
  """
  def rescaling([], _), do: []
  def rescaling(xs, [a, b]) do
    {min, max} = Enum.min_max(xs)
    if max == min, do: raise ArgumentError, "the min and the max values of the list have to be different"
    xs |> Enum.map(&rescaling_value(&1, min, max, a, b))
  end

  defp rescaling_value(x, min, max, a, b) do
    (((b - a) * (x - min)) / (max - min)) + a
  end

  @doc """
  Makes the values of each number in the data have zero-mean and unit-variance.
  """
  def standardization(xs) do
    {mean, stand_dev} = {mean(xs), standard_deviation(xs)}
    if stand_dev == 0, do: raise ArgumentError, "the given list of numbers has zero standard deviation"
    xs |> Enum.map(&((&1 - mean) / stand_dev))
  end
end
