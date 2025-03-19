require "minitest/autorun"
require_relative "yahtzee_scoring"

class TestYahtzeeScoring < Minitest::Test
  def test_yahtzee
    assert_equal({ category: :yahtzee, score: 50 }, YahtzeeScoring.best_score([6, 6, 6, 6, 6]))
    assert_equal({ category: :yahtzee, score: 50 }, YahtzeeScoring.score_yahtzee([4, 4, 4, 4, 4]))
    assert_equal({ category: nil, score: 0 }, YahtzeeScoring.score_yahtzee([4, 4, 4, 4, 0]))
  end

  def test_large_straight
    assert_equal({ category: :large_straight, score: 40 }, YahtzeeScoring.best_score([2, 3, 4, 5, 6]))
    assert_equal({ category: :large_straight, score: 40 }, YahtzeeScoring.best_score([1, 2, 3, 4, 5]))
    assert_equal({ category: :large_straight, score: 40 }, YahtzeeScoring.score_large_straight([5, 2, 3, 1, 4]))
    assert_equal({ category: nil, score: 0 }, YahtzeeScoring.score_large_straight([1, 5, 3, 4, 5]))
  end

  def test_small_straight
    assert_equal({ category: :small_straight, score: 30 }, YahtzeeScoring.best_score([1, 2, 3, 4, 3]))
    assert_equal({ category: :small_straight, score: 30 }, YahtzeeScoring.best_score([2, 3, 4, 5, 5]))
    assert_equal({ category: :small_straight, score: 30 }, YahtzeeScoring.score_small_straight([4, 6, 3, 1, 2]))
    assert_equal({ category: nil, score: 0 }, YahtzeeScoring.score_small_straight([2, 5, 4, 5, 5]))
  end

  def test_full_house
    assert_equal({ category: :full_house, score: 25 }, YahtzeeScoring.best_score([3, 3, 3, 5, 5]))
    assert_equal({ category: :full_house, score: 25 }, YahtzeeScoring.score_full_house([3, 5, 3, 5, 5]))
    assert_equal({ category: nil, score: 0 }, YahtzeeScoring.score_full_house([3, 3, 2, 5, 5]))
  end

  def test_four_of_a_kind
    assert_equal({ category: :four_of_a_kind, score: 27 }, YahtzeeScoring.best_score([6, 6, 6, 6, 3]))
    assert_equal({ category: :four_of_a_kind, score: 23 }, YahtzeeScoring.score_four_of_a_kind([5, 3, 5, 5, 5]))
    assert_equal({ category: nil, score: 0 }, YahtzeeScoring.score_four_of_a_kind([6, 3, 6, 6, 3]))
  end

  def test_three_of_a_kind
    assert_equal({ category: :three_of_a_kind, score: 21 }, YahtzeeScoring.best_score([6, 6, 6, 2, 1]))
    assert_equal({ category: :three_of_a_kind, score: 21 }, YahtzeeScoring.score_three_of_a_kind([6, 6, 6, 2, 1]))
    assert_equal({ category: nil, score: 0 }, YahtzeeScoring.score_three_of_a_kind([6, 5, 6, 2, 1]))
  end

  def test_chance
    # This test expects Chance to be the fallback when no other categories score higher
    assert_equal({ category: :chance, score: 17 }, YahtzeeScoring.best_score([1, 2, 3, 5, 6]))
    assert_equal({ category: :chance, score: 17 }, YahtzeeScoring.score_chance([1, 2, 3, 5, 6]))
  end

  def test_upper_section
    # Chance must be turned off, otherwise chance will always score higher than all upper section categories
    assert_equal({ category: :sixes, score: 12 }, YahtzeeScoring.best_score([6, 6, 1, 1, 2], false))
    assert_equal({ category: :fives, score: 10 }, YahtzeeScoring.best_score([5, 4, 4, 5, 1], false))
    assert_equal({ category: :fours, score: 8 }, YahtzeeScoring.best_score([4, 4, 5, 2, 1], false))
    assert_equal({ category: :threes, score: 6 }, YahtzeeScoring.best_score([3, 3, 1, 2, 1], false))
    # Cannot test best_score for twos unless restricted
    # assert_equal({ category: :twos, score: 4 }, YahtzeeScoring.best_score([2, 1, 1, 2, 1], false))
    # assert_equal({ category: :ones, score: 2 }, YahtzeeScoring.best_score([3, 5, 6, 1, 1], false))
  end
end
