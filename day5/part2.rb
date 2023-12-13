=begin
--- Problem
- given a map stage and a seed range, send the seed range through, 
  ultimately returning several ranges


--- Methods

- source_to_destinateion(seed_range, map_stage)
  - completed_ranges = []

  - example range: 79...79 + 14 = (79...93)
  - example map_stage:
    [98...100, 50...98]
    [-48,       2]

  - iterate over the map_stage source ranges
    - pass into find_overlap(seed_range, source range)
    - 1. if it returns nil, move to next source range
    - 2. if it returns one range, we're done.
      apply this difference to the entire range, push it into
      completed_ranges, and return completed_ranges
    - 3. if it returns two ranges,
      - process the first range with the current difference
        - push this processed range into completed_ranges
        - keep going with the second range
    - THIS DOESN'T WORK IF IT'S IN THE MIDDLE
=end

require_relative "part2formatting.rb"
input = File.open('input.txt').readlines
# input = File.open('testinput.txt').readlines

map_and_seeds = make_map(input)
map = map_and_seeds[0]
seeds = map_and_seeds[1] 

def ranges_overlap?(range_a, range_b)
  range_b.begin <= range_a.end && range_a.begin <= range_b.end 
end

def find_overlap(source, target)
  return nil unless ranges_overlap?(source, target)

  if source.begin >= target.begin && source.end <= target.end
    return [source]
  end

  if source.begin < target.begin && source.end > target.end
    return [target, (source.begin...target.begin), (target.end + 1...source.end)]
  end

  if source.begin > target.begin
    return [(source.begin...target.end), (target.end...source.end)]
  else
    return [(target.begin...source.end), (source.begin...target.begin)]
  end
end

def get_location_from_seed(seed, map)
  current_id = seed

  map.each do |conversion|
    source_ids = conversion[0]
    differences = conversion[1]

    found_id = nil
    source_ids.each_with_index do |range, index|
      if range.cover?(current_id)
        found_id = current_id + differences[index]
      end
    end
    
    if found_id
      current_id = found_id
    end
  end
  current_id
end


def find_smallest_location_with_ranges(seed_ranges, map)
  current_seeds = seed_ranges
  next_seeds = []

  map.each do |stage|
    current_seeds.each do |seed_range|
      next_seeds.concat(process_one_stage(stage, seed_range))
    end
    current_seeds = next_seeds
    next_seeds = []
  end

  current_seeds.min_by do |range|
    range.begin
  end.begin
end

def process_one_stage(stage, seed_range)
  processed_ranges = []
  difference = stage[1]
  stage = stage[0]
  to_be_processed = [seed_range]

  stage.each_with_index do |source_range, index|

    range_to_process = to_be_processed.pop
    overlap = find_overlap(range_to_process, source_range)

    if !overlap
      to_be_processed << range_to_process
      next
    end

    if overlap.length == 1
      start = overlap[0].begin + difference[index]
      stop = overlap[0].end + difference[index]
      processed_ranges << (start...stop)
    elsif overlap.length > 1
      match = overlap.shift
      start = match.begin + difference[index]
      stop = match.end + difference[index]
      processed_ranges << (start...stop)
      to_be_processed.concat(overlap)
    end

    return processed_ranges if to_be_processed.empty?
  end
  if to_be_processed.length > 0
    processed_ranges.concat(to_be_processed)
  end

  processed_ranges
end

p find_smallest_location_with_ranges(seeds, map) # 148041808