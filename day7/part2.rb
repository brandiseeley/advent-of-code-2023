input = File.open('input.txt').readlines
# test = File.open('testinput.txt').readlines

def format_hands(input)
  hands = input.map do |line|
    parts = line.split
    cards = parts[0].split('')
  
    cards = cards.map do |card|
      case card
      when 'T' then 10
      when 'J' then 1
      when 'Q' then 12
      when 'K' then 13
      when 'A' then 14
      else
        card.to_i
      end
    end
  
    bid = parts[1].to_i
    Hand.new(cards, bid)
  end
end

class Hand
  attr_reader :value, :cards, :bid

  def initialize(cards, bid)
    @cards = cards
    @bid = bid
    @value = calculate_value
  end

  def calculate_value
    quantities = @cards.tally

    number_of_js = quantities[1]
    quantities.delete(1)
    quantities = quantities.values.sort.reverse

    if number_of_js && quantities.length > 0
      quantities[0] = quantities[0] + number_of_js
    end

    if number_of_js == 5
      quantities = [5]
    end

    if quantities[0] == 5
      7 # five of a kind
    elsif quantities[0] == 4
      6 # four of a kind
    elsif quantities[0] == 3 && quantities[1] == 2
      5 # full house
    elsif quantities[0] == 3
      4 # three of a kind
    elsif quantities[0] == 2 && quantities[1] == 2
      3 # two pair
    elsif quantities[0] == 2
      2 # one pair
    else
      1
    end
  end
end

def rank_hands(hands)
  hands.sort! do |b, a|
    if a.value != b.value
      a.value <=> b.value
    else
      a.cards <=> b.cards
    end  
  end
  hands
end

def apply_bids(ranked_hands)
  total = 0
  rank = 1

  ranked_hands.reverse.each do |hand|
    total += (hand.bid * rank)
    rank += 1
  end
  
  total
end

hands = format_hands(input)
ranked_hands = rank_hands(hands)
p apply_bids(ranked_hands) # 246436046