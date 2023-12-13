# Had to make a brute force solution to debug recursive solution

input = File.open('input.txt').readlines
# test = File.open('testinput.txt').readlines

def parse_input(input)
  rows = []
  input.each do |line|
    parts = line.chomp.split(' ')
    groups = parts[1].split(',').map(&:to_i)
    rows << [parts[0], groups]
  end

  rows
end

def all_possible_strings(complete_half, incomplete_half)

  if incomplete_half.empty?
    return [complete_half]
  else
    next_question_mark_index = incomplete_half.index('?')
    return [complete_half + incomplete_half] unless next_question_mark_index
    first_half = complete_half + incomplete_half[0, next_question_mark_index]
    second_half = incomplete_half[next_question_mark_index + 1..-1]
    complete_a = first_half + '.'
    complete_b = first_half + '#'
    return all_possible_strings(complete_a, second_half).concat(all_possible_strings(complete_b, second_half))
  end
end

lines = parse_input(input)

sum = 0

lines.each_with_index do |line, index|
  string = line[0]
  groups = line[1]
  all_strings = all_possible_strings('', string)
  all_strings.filter! { |string| string.count('#') == groups.sum}
  all_strings.filter! do |string| 
    groups_of_springs = string.split(/\.+/).filter {|group| group != '' }
    groups_of_test_string = groups_of_springs.map { |springs| springs.length }
    groups_of_test_string == groups
  end

  puts "#{index}:#{string}:#{all_strings.length}"
  sum += all_strings.length
end

p sum # 7025

