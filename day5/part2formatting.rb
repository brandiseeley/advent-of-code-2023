def make_map(input)
  parts = []
  seeds_line = input.shift.split(' ')
  seeds_line.shift
  seeds_line.map!(&:to_i)
  seeds = make_seed_ranges(seeds_line)
  
  input.filter! { |line| line != "\n" }.map! { |line| line.chomp() }

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

def make_seed_ranges(seed_line)
  seeds = []
  seed_line.each_with_index do |start_or_length, index|
    if index.even?
      start = start_or_length
      stop = start + seed_line[index + 1]
      seeds << (start...stop)
    end
  end
  seeds
end