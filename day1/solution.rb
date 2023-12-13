=begin
--- first_number helper (string, targets)
- set first_number = null
- set first_index = strings length
- Iterate over string versions of digits and word numbers 1-9
- search the string for these matches
  - if a match is found, and the index is less than the first_index
    - replace found_index with this index
    - replace first_number with this number
- convert the first_number to its digit version if needed and return

--- last_number helper
- set last_number = null
- set last_index = 0
- Iterate over string versions of digits and word numbers 1-9
- search the string for these matches
  - if a match is found, and the index is greater than than the last_index
    - replace last_index with this index
    - replace last_number with this number
- convert the last_number to its digit version if needed and return

--- Main
- Split input
- set sum to 0
- iterate over strings
  - use helpers to get first number and last number
  - concatenate them together and turn them into an integer
  - add them to sum

- return sum
=end


input = File.open('input.txt').readlines.map(&:chomp)

WORD_NUMBERS = %w(zero one two three four five six seven eight nine)
DIGITS_AND_WORDS = %w(1 2 3 4 5 6 7 8 9 one two three four five six seven eight nine)

def first_number(string)
  first_number = nil
  first_index = string.length + 1

  DIGITS_AND_WORDS.each do |target|
    index = string.index(target)
    if index && (index < first_index)
      first_number = target
      first_index = index
    end
  end
  
  if WORD_NUMBERS.include?(first_number)
    (WORD_NUMBERS.index(first_number)).to_s
  else
    first_number
  end
end

def last_number(string)
  last_number = nil
  last_index = -1

  DIGITS_AND_WORDS.each do |target|
    index = string.rindex(target)
    if index && (index > last_index)
      last_number = target
      last_index = index
    end
  end
  
  if WORD_NUMBERS.include?(last_number)
    (WORD_NUMBERS.index(last_number)).to_s
  else
    last_number
  end
end

def sum_first_and_last(lines)
  sum = 0
  lines.each do |line|
    digit = (first_number(line) + last_number(line)).to_i
    sum += digit
  end
  sum
end

test = 
['two1nine',
'eightwothree',
'abcone2threexyz',
'xtwone3four',
'4nineeightseven2',
'zoneight234',
'7pqrstsixteen']

p sum_first_and_last(test) # 281
p sum_first_and_last(input) # 54875

