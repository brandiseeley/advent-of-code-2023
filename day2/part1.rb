=begin
--- Problem
- Given a bunch of 'games', each containing multiple 'rounds', return the sum of the games IDs for which ALL ROUNDS ARE POSSIBLE
- Each round contains some colors and a number of blocks associated with that color
- To be a valid round, the round should be possible to be made up of:
  - 12 red cubes
  - 13 green cubes
  - 14 blue cubes

--- Examples
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green

For these games:
  - 1 is possible
  - 2 is possible
  - 3 is not because we have 20 red
  - 4 is not because we have 15 blue
  - 5 is possible

  the sum of 5, 2, and 1 is 8

---- Procedure
- Split up the input into an array of games, where each game is an array of rounds
  - The index of each game will corespond with its ID - 1
  [ 
    [['3 blue', '4 red', '2green'], [...], ...]],
    [game],
    [[round], [round], ...],
    ...
  ]

- init sum to 0
- iterate over games with index
  - Iterate over the rounds
    - check validity of each round
    - If all rounds are valid rounds, add 1 + current index to sum

--- VALID ROUND HELPER
- iterate over strings of a round with index ex: ['2', 'red', '3', 'blue']
  - If the current string is a digit
    - Check what color the string following it is
    - If the digit is larger than the maximum number associated
      with this color, return false
- if we make it here return true

=end

input = File.open('input.txt').readlines.map(&:chomp)

def parse_input(input)
  input.map do |line_text|
    line = line_text[8..line_text.length]
    rounds = line.split('; ')
    rounds.map do |round|
      round.split(' ').map { |color| color.delete(',') }
    end
  end
end


AVAILABLE_CUBES = { 'red'=> 12, 'green'=> 13, 'blue'=> 14 }

def valid_round?(round)
  round.each_with_index do |number_or_color, index|
    next if !is_number?(number_or_color)
    number = number_or_color.to_i
    color = round[index + 1]
    return false if number > AVAILABLE_CUBES[color]
  end
  true
end

def is_number?(string)
  string.to_i.to_s == string
end 

def sum_round_numbers(games)
  sum = 0

  games.each_with_index do |game, index|
    if game.all? { |round| valid_round?(round) }
      sum += (index + 1)
    end
  end

  sum
end

games = parse_input(input)
p sum_round_numbers(games) # 2439
