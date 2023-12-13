=begin
--- Problem
- Given a matrix of numbers, symbols, and periods
  return the sum of all part numbers present in the matrix

- A number is a part number if it is adjacent to a symbol
  - this means above, below, or diagonally in any direction
  - numbers can be multiple digits


--- Examples

467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..

58 and 114 are NOT part numbers, everything else is

1. Parse the numbers into arrays of indices
2. For each number array, figure out if its indices are adjacent to anything
   except a period
3. sum all numbers who ARE

--- Algorithm
1. get all indices of numbers
- init number_indices to an empty array
- Iterate over each row of the input
  - set current number to empty array
  - for each character in the input:
  - IF IT is a number, push it into current number
  - IF IT is not a number AND current number is non-empty
    - push current number into number_indices and reset to an empty array
  - IF IT is not a number AND current number is empty, keep going
- return array of indices

2. Helper to check if there is an adjacent symbol
  - given an idice pair and a matrix, check against all surrounding sqrs
  - If the surrounding square is anything except a period or number
    - return true
  - return false

3. MAIN
  - set sum to 0
  - Collect all numbers as indice arrays
  - iterate over numbers
    - if ANY of the numbers are next to a symbol,
      add this number to the sum

Differences:
-1 -1  -1 0  -1 1
 0 -1   0 0   0 1
 1 -1   1 0   1 1
=end

input = File.open('input.txt').readlines.map(&:chomp)
# test = File.open('testinput.txt').readlines.map(&:chomp)
matrix = input.map { |row| row.split('') }

def sum_parts(matrix)
  sum = 0
  all_numbers = get_number_indices(matrix)

  all_numbers.each do |indices|
    if indices.any? { |pair| neighbor_of_symbol?(matrix, pair) }
      number_strings = indices.map { |pair| matrix[pair[0]][pair[1]] }
      sum += number_strings.join('').to_i
    end
  end
  sum
end

def neighbor_of_symbol?(matrix, pair)
  differences = [ [-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 0], [0, 1], [1, -1], [1, 0], [1, 1] ]
  differences.any? do |difference|
    neighbor = [pair[0] + difference[0], pair[1] + difference[1]]
    in_matrix?(matrix, neighbor) && is_symbol?(matrix, neighbor)
  end
end

def is_symbol?(matrix, pair)
  character = matrix[pair[0]][pair[1]]
  character.match?(/[^0-9.]/)
end

def in_matrix?(matrix, pair)
  row_index = pair[0]
  column_index = pair[1]

  row_index.between?(0, matrix.length - 1) && column_index.between?(0, matrix[0].length - 1)
end

def get_number_indices(matrix)
  numbers_indices = []
  matrix.each_with_index do |row, row_index|
    current_number = []
    row.each_with_index do |character, character_index|
      # if the symbol is a number
      if character.match?(/[0-9]/)
        current_number << [row_index, character_index]
      elsif current_number.length > 0
        numbers_indices << current_number
        current_number = []
      end
    end

    numbers_indices << current_number if current_number.length > 0
  end

  numbers_indices
end

p sum_parts(matrix) # test: 4261, problem: 550934