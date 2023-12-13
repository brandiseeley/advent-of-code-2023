=begin
--- Problem ---
- Given an array of nested arrays
  - check for 'wins' in each card
  - for each 'win', duplicate the next card in the game

  - ex: if you have two wins on card 1, then you get another card 2
  and another card 3

  - if then card 2 has 3 wins, then you get 3 more of card 3 and 3 more 
    of card 4

  - keep going until we're out of cards. Count the total number of cards

--- Examples ---
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11

1 1: 4
1 2: 2
1 3: 2
1 4: 1
1 5: 0
1 6: 0

1 1: 4 x
2 2: 2
2 3: 2
2 4: 1
2 5: 0
1 6: 0


1 1: 4 
2 2: 2 x
4 3: 2
4 4: 1
2 5: 0
1 6: 0

1 1: 4 
2 2: 2 
4 3: 2 x
8 4: 1
6 5: 0
1 6: 0

1 1: 4 
2 2: 2 
4 3: 2 
8 4: 1 x
14 5: 0
1 6: 0

1 1: 4 
2 2: 2 
4 3: 2 
8 4: 1 
14 5: 0 x
1 6: 0

--- Algorithm ---

- Create a quantity array that is populated with 1s equivelant to
  the length of the cards array

- iterate over each card
  - calculate number of wins
  - fetch quantity of this card

  - quantity of this card times
    - number of win times, go to the quantity array,
      STARTING at the current index plus 1
      - increment each by 1

- sum quantity array

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

def calculate_points(card)
  winners = card[0]
  chosen = card[1]
  winners.intersection(chosen).length
end

def duplicate_cards(cards)
  quantity_counter = [1] * cards.length

  cards.each_with_index do |card, index|
    wins = calculate_points(card)
    number_of_cards = quantity_counter[index]

    (index + 1).upto(index + wins) do |index_to_duplicate|
      quantity_counter[index_to_duplicate] = quantity_counter[index_to_duplicate] + number_of_cards
    end

  end
  quantity_counter.sum
end

p duplicate_cards(cards) # 9721255