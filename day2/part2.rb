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

def minimum_colors(round)
  minimums = { 'red' => 0, 'blue' => 0, 'green' => 0 }

  round.each_with_index do |number_or_color, index|
    next if !is_number?(number_or_color)
    number = number_or_color.to_i
    color = round[index + 1]

    minimums[color] = minimums[color] < number ? number : minimum[color]
  end
  
  return minimums
end

def is_number?(string)
  string.to_i.to_s == string
end 

def sum_round_numbers(games)
  sum_of_powers = 0

  games.each do |game|
    game_minimum = { 'red' => 0, 'blue' => 0, 'green' => 0 }
    game.each do |round|
      minimum_for_round = minimum_colors(round)
      minimum_for_round.each do |color, minimum|
        if minimum > game_minimum[color]
          game_minimum[color] = minimum
        end
      end
    end

    power = game_minimum.values.reduce(&:*)
    sum_of_powers += power
  end
  sum_of_powers
end

games = parse_input(input)
p sum_round_numbers(games) # 63711
