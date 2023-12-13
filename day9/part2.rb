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
  end

  def next_value
    temp_values = []

    @rows.reverse.each_with_index do |row, index|
      if index == 0
        temp_values << 0
        next
      end

      first_from_bigger_row = @rows[@rows.length - (index + 1)][0]
    
      temp_values << first_from_bigger_row - temp_values[-1]
    end

    return temp_values[-1]
  end

  def build_tree
    loop do
      if last_row.all? {|el| el == 0}
        return
      else
        next_row
      end
    end
  end

  def last_row
    @rows[-1]
  end

  def next_row
    last_row = last_row()

    new_row = []
    last_row.each_with_index do |element, index|
      if index + 1 >= last_row.length
        @rows << new_row
        return new_row
      end

      new_row << (last_row[index + 1] - element)
    end
  end

  def to_s
    str = ''
    @rows.each do |row|
      str += "\n---" + row.to_s + "---"
    end
    str
  end
end

rows = parse_rows(input)
sum = 0
rows.each do |initial_row|
  history = History.new(initial_row)
  history.build_tree
  sum += history.next_value
end

p sum # 1068
