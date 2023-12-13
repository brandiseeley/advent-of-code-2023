=begin
--- Problem
- Given the same matrix, find all '*' symbols that are touching
  exactly TWO numbers
  - multiply these two numbers together for each * to get the gear ratio
  - add together all of the gear ratios

--- Examples


--- Algorithm
- sum = 0

- find numbers just the same
- make empty hash for gears
- iterate over numbers
  - init neighbor_gears to an empty array
  - iterate over each pair
    - if the pair is a neighbor of a gear, push the gear into neighbor_gears
      UNLESS IT'S ALREADY THERE
  - Now iterate over neighbor_gears (if any)
    - add the gear to a hash. If the gear already exists as a key,
      push it into its array
      - if it doesn't already exist as a key, add it as a key and push
        the number into it's value array

- iterate over the gear hash keys
  - if the array for that gear contains exactly two numbers
    - multiply them together and add them to the sum
=end

input = File.open('input.txt').readlines.map(&:chomp)
test = File.open('testinput.txt').readlines.map(&:chomp)
matrix = input.map { |row| row.split('') }

def sum_gear_ratios(matrix)
  sum = 0
  number_indices = get_number_indices(matrix)
  gears = {}

  number_indices.each do |number|
    neighbor_gears = []
    integer = number.map { |pair| matrix[pair[0]][pair[1]] }.join('').to_i

    number.each do |pair|
      current_neighbor_gears = find_neighbor_gears(matrix, pair)
      if current_neighbor_gears.length > 0
        neighbor_gears.concat(current_neighbor_gears)
      end
    end
    neighbor_gears.each do |gear|
      if gears.has_key?(gear) && !gears[gear].include?(integer)
        gears[gear] << integer
      elsif !gears.has_key?(gear)
        gears[gear] = [integer]
      end
    end
  end
  
  gears.each do |gear, number_array|
    if number_array.length == 2
      sum += (number_array[0] * number_array[1])
    end
  end

  sum
end

def find_neighbor_gears(matrix, pair)
  differences = [ [-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 0], [0, 1], [1, -1], [1, 0], [1, 1] ]
  gears = []

  differences.each do |difference|
    neighbor = [pair[0] + difference[0], pair[1] + difference[1]]
    if in_matrix?(matrix, neighbor) && is_gear?(matrix, neighbor)
      gears << neighbor
    end
  end

  gears
end

def is_gear?(matrix, pair)
  character = matrix[pair[0]][pair[1]]
  character == '*'
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

p sum_gear_ratios(matrix) # 81997870