input = File.open('input.txt').readlines

def make_hash(input)
  directions = input[0].chomp
  input.shift(2)

  hash = input.each_with_object({}) do |line, hash|
    parts = line.split(/[^A-Z0-9]+/)
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
  current_nodes = hash.keys.filter { |key| key.end_with?('A') }

  loop do
    return counter if current_nodes.all? { |key| key.end_with?('Z') }
  
    direction_index = counter % direction_length
    direction = directions[direction_index]

    current_nodes = current_nodes.map do |node|
      new_node = direction == 'R' ? hash[node][1] : hash[node][0]
      new_node
    end

    counter += 1
  end
end

def distance_between_zs(directions, hash, current_node)
  counter = 0
  direction_length = directions.length
  seen_zs_indices = []
  z_nodes_visited = []

  loop do
    if current_node.end_with?('Z')
      seen_zs_indices << counter
      z_nodes_visited << current_node
    end

    direction_index = counter % direction_length
    direction = directions[direction_index]

    current_node = direction == 'R' ? hash[current_node][1] : hash[current_node][0]

    counter += 1
    break if seen_zs_indices.length > 10
  end

  p z_nodes_visited
  p seen_zs_indices[-1] - seen_zs_indices[-2]
end

items = make_hash(input)
directions = items[0]
hash = items[1]

STARTING_NODES = %w(DPA QLA VJA GTA AAA XQA)

distances_between_zs = STARTING_NODES.map do |starting_node|
  distance_between_zs(directions, hash, starting_node)
end

p distances_between_zs.reduce(1, :lcm) # 18215611419223