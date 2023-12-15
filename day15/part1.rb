input = File.open('input.txt').readlines(chomp: true)
# input = File.open('testinput.txt').readlines(chomp: true)

def transform(string)
  current_value = 0

  string.each_char do |character|
    ascii_code = character.ord
    current_value += ascii_code
    current_value *= 17
    current_value = current_value.remainder(256)
  end

  current_value
end

parts = input[0].split(',')

sum = 0

parts.each do |part|
  sum += transform(part)
end

# p sum # 503487