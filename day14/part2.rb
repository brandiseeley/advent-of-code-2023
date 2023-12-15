=begin
- Calculate the weight on the northern beams after tilting
  the board 

- Tilt board left
  - Iterate over a row from left to right
  - set new row to an empty string
  - set current piece to an empty string
  - For each point
    - If it's a round rock:

1 -> 2 -> 3 -> 4 -> 5 < # 6 -> 7 -> 8 -> 9

1  2  3  4  5  6#  7  8  9  10
11 12 13

Each node will have to have an 'occupied' flag
Hash rocks won't be nodes
{ 1 => {'N': nil, "s" => ....}}
Node 1: N: nil, W: nil, S: 11, E: 2
Node 5: N: nil, W: 4, S: 15, E: nil

- When we move in a direction, we need to move from
  that direction backwards, to ensure that everything gets 
  stacked

- North: iterate over nodes as normal, 1, 2, 3, ...
- West: Iterate over nodes from left to right, as normal
        works just fine. 
- South: iterate over nodes from bottom to top. Reverse
         works just fine
- East: Left to right, backwards works fine

--- Data Structures ---
- Array of keys. These will just be integers representing
  each spot on the grid that isn't a stagnant rock

- Map. This will be a hash with each integer as a key
  The keys of the hash will be another hash containing:
  Occupied: true/false 'N' => , W => , S =>, E => 

- To tilt North, for example, we iterate over the keys of
  the hash
  - If the current node is not occupied, keep going.
  - If it is occupied, check what is at the direction, 'N'
  - If it is nil, keep going. If it is not nil, set occupied
    to false, and go to that next node and set occupied to 
    true. Check N. Keep doing this until you reach nil.

- How to make the Map?
- Set current key to 1
- Iterate over the rows with index, and then each element
  with index
  - If the current element is a hash, move on. This isn't in our
    map, BUT ADD 1 TO CURRENT KEY
  - If the current element is NOT a hash, add it to our map
    - When adding, we need to check if it's OCCUPIED
    - To get directions, check neighbors on the grid.
      - If it's a hash, this direction should be nil
      - if it's not a hash, this direction should be
        whatever key is associated with that square
=end

input = File.open('input.txt').readlines(chomp: true)
# input = File.open('testinput.txt').readlines(chomp: true)
SQUARE_ROCK = '#'
ROUND_ROCK = 'O'
EMPTY = '.'

def make_map(rows)
  grid = rows.map { |row| row.split('') }
  current_key = 1
  map = {}
  keys = []

  grid.each_with_index do |row, row_index|
    row.each_with_index do |item, column_index|
      if item == ROUND_ROCK || item == EMPTY
        occupied = item == ROUND_ROCK ? true : false

        coordinate_north = [row_index - 1, column_index]
        if in_bounds?(coordinate_north, grid) && item_at_coordinate(rows, coordinate_north) != SQUARE_ROCK
          north = key_for_coordinate(grid, coordinate_north)
        else
          north = nil
        end

        coordinate_south = [row_index + 1, column_index]
        if in_bounds?(coordinate_south, grid) && item_at_coordinate(grid, coordinate_south) != SQUARE_ROCK
          south = key_for_coordinate(grid, coordinate_south)
        else
          south = nil
        end

        coordinate_east = [row_index, column_index + 1]
        if in_bounds?(coordinate_east, grid) && item_at_coordinate(grid, coordinate_east) != SQUARE_ROCK
          east = key_for_coordinate(grid, coordinate_east)
        else
          east = nil
        end

        coordinate_west = [row_index, column_index - 1]
        if in_bounds?(coordinate_west, grid) && item_at_coordinate(grid, coordinate_west) != SQUARE_ROCK
          west = key_for_coordinate(grid, coordinate_west)
        else
          west = nil
        end

        map[current_key] = { 
                             'occupied' => occupied,
                             'north' => north,
                             'south' => south,
                             'east' => east,
                             'west' => west
                            }
      end

      current_key += 1
    end
  end
  map
end

def key_for_coordinate(grid, coordinate)
  (coordinate[0] * grid[0].length) + coordinate[1] + 1
end

def item_at_coordinate(grid, coordinate)
  grid[coordinate[0]][coordinate[1]]
end

def in_bounds?(coordinate, grid)
  return false unless positive_array_index(grid, coordinate[0])
  !!positive_array_index(positive_array_index(grid, coordinate[0]), coordinate[1])
end

def positive_array_index(array, index)
  return nil unless index >= 0
  array[index]
end

def tilt(map, direction)
  if direction == 'north' || direction == 'west'
    keys_to_traverse = map.keys
  else
    keys_to_traverse = map.keys.reverse
  end

  keys_to_traverse.each do |key|
    # Keep going if this spot doesn't have a round rock
    next unless map[key]['occupied']

    # Check direction we should go if there is a round rock
    next_location_key = map[key][direction]
    current_node_information = map[key]
    while next_location_key
      next_node_information = map[next_location_key]
      
      if next_node_information['occupied']
        break
      end
      current_node_information['occupied'] = false
      next_node_information['occupied'] = true

      current_node_information = next_node_information
      next_location_key = current_node_information[direction]
    end
  end
end

def one_spin(map)
  tilt(map, 'north')
  tilt(map, 'west')
  tilt(map, 'south')
  tilt(map, 'east')
  map
end

def calculate_weight(map)
  num_rows = 100
  row_counts = []
  row_count = 0
  1.upto(10000) do |key|
    if map.key?(key) && map[key]['occupied']
      row_count += 1
    end

    if key % 100 == 0
      row_counts << row_count
      row_count = 0
    end
  end

  weights_from_array(row_counts)
end

def weights_from_array(array)
  weight = array.length
  sum = 0
  array.each do |number_of_rocks|
    sum += (weight * number_of_rocks)
    weight -= 1
  end

  sum
end

map = make_map(input)

# This solution works for fewer spins, but not for 1000000000
# I analyzed the output of the weights for each spin, realizing that
# the weights end up repeating in a loop, then used modulo to find
# which of these repeated weights would be the same for 1000000000

200.times do |num|
  one_spin(map)
  num_spins = num + 1
  puts "#{num} : #{num % 36} #{calculate_weight(map)}"
end

# 87700
