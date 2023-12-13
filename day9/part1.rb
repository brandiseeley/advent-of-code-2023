=begin
--- Problem ---
- Given a row of numbers, create an upside down tree
  to build the tree, move right to left, creating a new
  row underneath the current one by subtracting the value
  on the left from the value on the right. 
- Each row below the current will be 1 shorter in length
- keep going until the entire row is zeros

- Then, figure out what a new row would look like,
  added to the right. This means a zero at the bottom,
  then adding the difference from the last row

--- Examples ---

0   3   6   9  12  15   *18 
  3   3   3   3   3   *3
    0   0   0   0   *0

next value in our row will be **18**
=end

input = File.open('input.txt').readlines
# input = File.open('testinput.txt').readlines

def parse_rows(input)
  input.map do |row|
    row.split(' ').map(&:to_i)
  end
end

class History
  attr_reader :rows

  def initialize(first_row)
    @rows = [first_row]
    build_tree
  end

  def next_value
    temp_values = [0]

    rows.reverse.each_with_index do |row, index|
      next if index == 0

      last_from_row_up = rows[@rows.length - (index + 1)][-1]
      temp_values << last_from_row_up + temp_values[-1]
    end

    return temp_values[-1]
  end

  private

  def build_tree
    while !last_row.all? {|el| el == 0}
      next_row
    end
  end

  def last_row
    rows[-1]
  end

  def next_row
    new_row = []
    last_row.each_with_index do |element, index|
      if index + 1 >= last_row.length
        rows << new_row
        return new_row
      end

      new_row << (last_row[index + 1] - element)
    end
  end
end

def sum_predicted_values(rows)
  sum = 0
  rows.each do |initial_row|
    history = History.new(initial_row)
    sum += history.next_value
  end

  sum
end

rows = parse_rows(input)
p sum_predicted_values(rows) # 1969958987
