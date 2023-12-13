input = File.open('input.txt').readlines
test = File.open('testinput.txt').readlines

MEMO = {}

def parse_input(input)
  rows = []
  input.each do |line|
    parts = line.chomp.split(' ')
    folded_springs = parts[0]

    unfolded_springs = ([folded_springs] * 5).join('?')
    folded_groups = parts[1].split(',').map(&:to_i)
    unfolded_groups = folded_groups * 5

    rows << ['.' + unfolded_springs + '.', unfolded_groups]
  end
  rows
end

def count_possible_matches(line, groups_to_fit, indentation)
  key = line.to_s + groups_to_fit.to_s
  if MEMO.keys.include?(key)
    return MEMO[key]
  end

  if groups_to_fit.length == 0
    return line.count('#') == 0 ? 1 : 0
  end

  matches_for_first_group = all_spots_for_group(line, groups_to_fit[0])

  if matches_for_first_group.length == 0
    results = 0
  else
    results = matches_for_first_group.map do |start_index|
      remaining_line = '.' + line[start_index + groups_to_fit[0] + 2..-1]

      count_possible_matches(remaining_line, groups_to_fit[1..-1], '  ' + indentation)
    end.sum
  end

  MEMO[key] = results
  return results
end

def all_spots_for_group(line, group)
  first_hash = line.index('#')
  indices = []
  current_index = 0
  
  while true
    group_start = line.index(/[\.\?]{1}(\?|#){#{group}}[\.\?]{1}/, current_index)

    break unless group_start
    break if first_hash && (group_start >= first_hash)

    indices << group_start
    current_index = group_start + 1
  end

  indices
end


test_rows = parse_input(test)
testsum = 0

test_rows.each do |row|
  possible_layouts = count_possible_matches(row[0], row[1], '|')
  testsum += possible_layouts
end

p testsum # 525152

# rows = parse_input(input)
# sum = 0

# rows.each_with_index do |row, index|
#   p index
#   possible_layouts = count_possible_matches(row[0], row[1], '|')
#   sum += possible_layouts
# end
# p sum # 11461095383315

