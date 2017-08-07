Code.require_file "../lib/preliminaries_problems.ex", __DIR__

ExUnit.start()
defmodule PreliminariesProblemsTest do
  use ExUnit.Case, async: true

  describe "Problem 2.1 (Use Bayes' rule)" do
    # At a party you meet a person who claims to have been to same school as you.
    # You vaguely recognise them, but can't remember properly, so decide to work
    # out how likely it is, given that:
    # 1) 1 in 2 of the people you vaguely recognise went to school with you
    # 2) 1 in 10 of the people at the party went to school with you
    # 3) 1 in 5 people at the party you vaguely recognise

    test "returns .25 likelihood the person went to school with you" do
      # probability the person went to school with you
      prior_the_same_school = 0.1
      # probability that you vaguely recognise person that is at the party
      prior_vaguely_recognise = 0.2
      # conditional probability of went to school with you given you vaguely recognise him/her
      same_school_given_rocognise = 0.5

      likelihood = PreliminariesProblems.likelihood(same_school_given_rocognise, prior_the_same_school, prior_vaguely_recognise)

      assert_in_delta likelihood, 0.25, 0.0001
    end
  end
end
