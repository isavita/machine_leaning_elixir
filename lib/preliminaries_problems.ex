defmodule PreliminariesProblems do
  def likelihood(condition_given_hypothesis, prior_hypothesis, prior_condition) do
    (condition_given_hypothesis * prior_hypothesis) / prior_condition
  end
end
