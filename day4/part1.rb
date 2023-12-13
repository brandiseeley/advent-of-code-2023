=begin
--- Problem ---
- Given a list of cards where each card contains winning numbers and 
  chosen numbers, return the total score of all games together.

- to calculate a cards score, you take the number of winning numbers
  - the first winning number gives you 1 score
  - any winning numbers after that double your score

  - Score = 2 ** (number of cards - 1)

--- Examples ---
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11

--- Algorithm ---
- Split input into two element nested arrays
  - each card is an array containing an array of winners
  - and an array of chosen
- find the intersection of these cards Array#intersection

Calculate the score

=end

input = File.open('input.txt').readlines.map(&:chomp)
test = File.open('testinput.txt').readlines.map(&:chomp)

cards = input.map { |card| card.split(':')[1] }
cards = cards.map do |card|
  left, right = card.split(' | ')[0..1]

  left = left.chomp.split(' ').map(&:to_i)
  right = right.chomp.split(' ').map(&:to_i)

  [left, right]
end

def calculate_points(cards)
  total = 0

  cards.each do |card_array|
    winners = card_array[0]
    chosen = card_array[1]

    matches = winners.intersection(chosen)

    if matches.length > 0
      total += (2 ** (matches.length - 1))
    end
  end

  total
end

p calculate_points(cards) # 25231