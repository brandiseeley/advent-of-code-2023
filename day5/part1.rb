=begin
--- Problem ---
- We have a map that give us information on how to grow different seeds
- we have several seeds that we need to plant

seeds: 79 14 55 13 -> Our seed numbers

seed-to-soil map:
FIRST COLUMN: DESTINATION START
SECOND COLUMN: SOURCE RANGE START
50 98 2 -> This line shows us information for 2 seeds and 2 soils, because the range is 2

98,99 -> 50,51

52 50 48
Seeds      soil
50...97 -> 52...99 

For any source that is included in a range, the destination is equal to the source number plus the difference between the two ranges

From this information, we can find that seed 98 should have soil 50, seed 99 should have soil 51


Sources that aren't mapped correspond to the same destination number

--- Examples ---

seeds: 79 14 55 13

Seed:79 -> 79+2 = 81:Soil -> fertilizer 81...

seed-to-soil map:
Soil   Seed   Range
50     98     2
52     50     48

soil-to-fertilizer map:
fertilizer  soil   range
0           15     37
37          52     2
39          0      15

=end


input = File.open('input.txt').readlines
# test = File.open('testinput.txt').readlines

def make_map(input)
  parts = []

  seeds = input.shift.split(' ')
  seeds.shift
  seeds.map!(&:to_i)

  input.filter! do |line|
    line != "\n"
  end

  input.map! do |line|
    line.chomp()
  end

  part_name = ''
  source_ranges = []
  differences = []

  input.each do |line|
    if line.start_with?(/[a-zA-Z]/)
      if part_name.empty?
        part_name = line
      else
        parts << [source_ranges, differences]
        part_name = line
        source_ranges = []
        differences = []
      end
      next
    end

    # If the line isn't a title
    numbers = line.split(' ').map(&:to_i)
    differences.push(numbers[0] - numbers[1])
    source_ranges.push((numbers[1]...(numbers[1] + numbers[2])))
  end

  parts << [source_ranges, differences]

  [parts, seeds]
end

map_and_seeds = make_map(input)
map = map_and_seeds[0]
seeds = map_and_seeds[1] 

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

def find_smallest_location(seeds, map)
  locations = []
  
  seeds.each do |seed|
    locations << get_location_from_seed(seed, map)
  end

  locations.min
end

p find_smallest_location(seeds, map) # 214922730