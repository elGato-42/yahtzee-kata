# check if any boxes already filled in
# compute score for each category
# take the category with the highest score

# refactor ideas:
# - upgrade to ruby 2.7, update readme
# - test suite does not test all methods or edge cases
# - bug? - chance does not act as a fallback
# - does not handle ties

# - reorg classes check if boxes filled in (maintain) - whose responsibility to keep track of scorecard state
# - CATEGORIES constant (readability)
# - start with highest possible category and stop when it's possible (performance) - where would chance fall
# - inline documentation


class YahtzeeScoring
  def self.best_score(roll, scoreChance = true)
    best_categories = []
    best_score = 0

    # either append category if a tie, or replace category if its score beats top score
    [score_upper_section(roll), score_lower_section(roll, scoreChance)].each do |section_score|
      if (section_score[:score] == best_score)
        best_categories += section_score[:categories]
        best_categories.uniq!
      elsif section_score[:score] > best_score
        best_score = section_score[:score]
        best_categories = section_score[:categories]
      end
    end

    { categories: best_categories.sort, score: best_score }
  end

  def self.score_upper_section(roll)
    best_categories = []
    best_score = 0

    (1..6).each do |num|
      score = roll.count(num) * num
      if score == best_score
        best_categories << num_to_category(num)
      elsif score > best_score
        best_score = score
        best_categories = [num_to_category(num)]
      end
    end

    { categories: best_categories, score: best_score }
  end

  def self.num_to_category(num)
    { 1 => :ones, 2 => :twos, 3 => :threes, 4 => :fours, 5 => :fives, 6 => :sixes }[num]
  end

  def self.score_lower_section(roll, scoreChance = true)
    best_categories = []
    best_score = 0

    categories = [
      score_four_of_a_kind(roll),
      score_three_of_a_kind(roll),
      score_full_house(roll),
      score_small_straight(roll),
      score_large_straight(roll),
      score_yahtzee(roll)
    ]

    categories << score_chance(roll) if scoreChance

    categories.each do |result|
      if result[:score] == best_score
        best_categories << result[:category]
      elsif result[:score] > best_score
        best_score = result[:score]
        best_categories = [result[:category]]
      end
    end

    { categories: best_categories, score: best_score }
  end

  def self.score_three_of_a_kind(roll)
    roll.each do |num|
      return { category: :three_of_a_kind, score: roll.sum } if roll.count(num) >= 3
    end
    { category: nil, score: 0 }
  end

  def self.score_four_of_a_kind(roll)
    roll.each do |num|
      return { category: :four_of_a_kind, score: roll.sum } if roll.count(num) >= 4
    end
    { category: nil, score: 0 }
  end

  def self.score_full_house(roll)
    counts = roll.tally.values.sort
    return { category: :full_house, score: 25 } if counts == [2, 3]
    { category: nil, score: 0 }
  end

  def self.score_small_straight(roll)
    unique_sorted = roll.uniq.sort
    straights = [[1, 2, 3, 4], [2, 3, 4, 5], [3, 4, 5, 6]]
    return { category: :small_straight, score: 30 } if straights.any? { |s| (s - unique_sorted).empty? }
    { category: nil, score: 0 }
  end

  def self.score_large_straight(roll)
    unique_sorted = roll.uniq.sort
    return { category: :large_straight, score: 40 } if unique_sorted == [1, 2, 3, 4, 5] || unique_sorted == [2, 3, 4, 5, 6]
    { category: nil, score: 0 }
  end

  def self.score_yahtzee(roll)
    return { category: :yahtzee, score: 50 } if roll.uniq.length == 1
    { category: nil, score: 0 }
  end

  def self.score_chance(roll)
    { category: :chance, score: roll.sum }
  end
end
