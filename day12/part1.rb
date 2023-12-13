=begin
- to caclulate the sum, we need to add in groups.
- when we try to add in a group, there are a few possibilities:
- Either this is the last group, and we should just add how many there
  are left
- nothing fits, and we return zero
- or this isn't the last group, and we map


=end
input = File.open('input.txt').readlines
test = File.open('testinput.txt').readlines

MEMO = {}

def parse_input(input)
  rows = []
  input.each do |line|
    parts = line.chomp.split(' ')
    groups = parts[1].split(',').map(&:to_i)
    rows << ['.' + parts[0] + '.', groups]
  end

  rows
end

def count_possible_matches(line, groups_to_fit, indentation)
  key = line.to_s + groups_to_fit.to_s
  if MEMO.keys.include?(key)
    return MEMO[key]
  end

  matches_for_first_group = all_spots_for_group(line, groups_to_fit[0])

  if matches_for_first_group.length == 0
    results = 0
  elsif groups_to_fit.length == 1
    matches = matches_for_first_group
    # Check that after the match, there aren't any leftover #s
    matches.filter! do |match_index|
      temp_line = line.dup
      temp_line[match_index..match_index + groups_to_fit[0]] = '.' * groups_to_fit[0]
      temp_line.count('#') == 0
    end

    results = matches.length
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

p testsum # 21


rows = parse_input(input)
sum = 0

rows.each_with_index do |row, index|
  possible_layouts = count_possible_matches(row[0], row[1], '|')
  sum += possible_layouts
end
p sum # 7025

