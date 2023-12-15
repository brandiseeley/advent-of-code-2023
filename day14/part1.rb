input = File.open('input.txt').readlines(chomp: true)
# input = File.open('testinput.txt').readlines(chomp: true)


def make_columns(rows)
  columns = []

  rows[0].length.times do |column_index|
    column = []
    rows.length.times do |row_index|
      column << rows[row_index][column_index]
    end
    columns << column
    column = []
  end

  columns
end

columns = make_columns(input)

total_weight = 0
columns.each do |column|
  current_weight = column.length

  column.each_with_index do |element, index|
    if element == 'O'
      total_weight += current_weight
      current_weight -= 1
    elsif element == '#'
      current_weight = column.length - index - 1
    end
  end
end

p total_weight # 106648