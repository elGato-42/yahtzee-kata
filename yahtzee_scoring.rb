# check if any boxes already filled in
# compute score for each category
# take the category with the highest score

# refactor ideas:
# - upgrade to ruby 2.7, update readme
# - test suite does not test all methods or edge cases
# - bug? - chance does not act as a fallback
# - does not handle ties
# - (out of scope) reorg classes check if boxes filled in (maintain) - whose responsibility to keep track of scorecard state
  # You can imagine another class Scorecard who is responsible for state -
  #  @scores = {sixes: 12, four_of_a_kind: 27, three_of_a_kind: nil}
  #  possible_categories = YahtzeeScoring.best_score([6, 6, 1, 1, 2]
  #  select_category = possible_categories.find { |category| scorecard[category].nil? }
# - CATEGORIES constant (readability)

# - start with highest possible category and stop when it's possible (performance) - where would chance fall
# - inline documentation


class YahtzeeScoring
  FULL_HOUSE_SCORE = 25
  SMALL_STRAIGHT_SCORE = 30
  LARGE_STRAIGHT_SCORE = 40
  YAHTZEE_SCORE = 50

  SMALL_STRAIGHTS = [[1, 2, 3, 4], [2, 3, 4, 5], [3, 4, 5, 6]]
  LARGE_STRAIGHTS = [[1, 2, 3, 4, 5], [2, 3, 4, 5, 6]]

  def self.best_score(roll, scoreChance = true)
    best_categories = []
    best_score = 0

    all_sections = [score_upper_section(roll), score_lower_section(roll, scoreChance)]
    all_sections.each do |section|
      best_categories, best_score = find_best_score(best_categories, best_score, section[:score], section[:categories])
    end

    { categories: best_categories.sort, score: best_score }
  end

  def self.score_upper_section(roll)
    best_categories = []
    best_score = 0

    (1..6).each do |num|
      score = roll.count(num) * num
      current_categories = [num_to_category(num)]
      best_categories, best_score = find_best_score(best_categories, best_score, score, current_categories)
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
      best_categories, best_score = find_best_score(best_categories, best_score, result[:score], [result[:category]])
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
    return { category: :full_house, score: FULL_HOUSE_SCORE } if counts == [2, 3]
    { category: nil, score: 0 }
  end

  def self.score_small_straight(roll)
    unique_sorted = roll.uniq.sort
    return { category: :small_straight, score: SMALL_STRAIGHT_SCORE } if SMALL_STRAIGHTS.any? { |s| (s - unique_sorted).empty? }
    { category: nil, score: 0 }
  end

  def self.score_large_straight(roll)
    unique_sorted = roll.uniq.sort
    return { category: :large_straight, score: LARGE_STRAIGHT_SCORE } if LARGE_STRAIGHTS.any? { |s| s == unique_sorted }
    { category: nil, score: 0 }
  end

  def self.score_yahtzee(roll)
    return { category: :yahtzee, score: YAHTZEE_SCORE } if roll.uniq.length == 1
    { category: nil, score: 0 }
  end

  def self.score_chance(roll)
    { category: :chance, score: roll.sum }
  end

  private_class_method

  def self.find_best_score(best_categories, best_score, current_score, current_categories)
    if current_score == best_score
      best_categories.concat(current_categories)
      best_categories.uniq!
    elsif current_score > best_score
      best_score = current_score
      best_categories = current_categories
    end
    [best_categories, best_score]
  end
end
