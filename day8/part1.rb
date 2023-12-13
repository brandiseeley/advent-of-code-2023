=begin
--- Probelem
- Given a map of nodes, where each node points to two other nodes,
  a left node and a right node
- follow the nodes until you get to ZZZ using the instructions
=end

input = File.open('input.txt').readlines

TARGET = 'ZZZ'
RIGHT = 'R'

def make_hash(input)
  directions = input[0].chomp
  input.shift(2)

  hash = input.each_with_object({}) do |line, hash|
    parts = line.split(/[^A-Z]+/)
    label = parts[0]
    left = parts[1]
    right = parts[2]
    hash[label] = [left, right]
  end

  [directions, hash]
end

def find_ZZZ(directions, hash)
  counter = 0
  direction_length = directions.length
  current_node = 'AAA'

  loop do
    return counter if current_node == TARGET

    direction_index = counter % direction_length
    direction = directions[direction_index]

    if direction == RIGHT
      current_node = hash[current_node][1]
    else
      current_node = hash[current_node][0]
    end

    counter += 1
  end
end

items = make_hash(input)
directions = items[0]
hash = items[1]

p find_ZZZ(directions, hash) # 12361
