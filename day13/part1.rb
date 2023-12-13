=begin
--- Problem ---
- Given a grid of 
  ash: .
  rock: #

You need to find the line, either horizontal or vertical,
in which the pattern is reflected/mirrored

--- Examples ---
    >< 5 rows to the left of the reflection point
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.
    ><

#...##..#
#....#..#
..##..###
#####.##.V -> 4 rows above the reflection point
#####.##.^
..##..###
#....#..#

For each grid, find the line of reflection
- If we reflect across a vertical line
  add the number of column to the left of the line
- If we reflect accross a horizontal line,
  add the number of rows ABOVE the reflection line TIMES 100

in this example, we have 5 left columns and 4 above rows
  5 + (100 * 4) = 405

--- Algorithm ---
- What does it mean to have a reflection? (with rows)
  - First, we must have Two identical rows in a row 
    - Then, we must iterate out and have all identical columns OR reach the end of one side


- Iterate from 0 up to the number of rows - 2
  - set current row to row at this index
  - set next row to row at this index + 1
  - IF THE TWO ROWS AREN'T EQUAL, next
  - IF THE TWO ROWS ARE EQUAL
    - Set offset counter to 1
    - set earlier row to this index minus the offset
    - set later row to this index + 1 + offset
    - If either rows don't exist, return this index
    - If the rows are different, return false

=end

input = File.open('input.txt').readlines(chomp: true)
# input = File.open('testinput.txt').readlines(chomp: true)

def separate_grids(input)
  grids = []
  rows = []

  input.each do |line|
    if line == ''
      grids << Grid.new(rows)
      rows = []
    else
      rows << line
    end
  end

  grids << Grid.new(rows)
  grids
end

class Grid
  attr_reader :rows, :columns

  def initialize(input)
    @rows = input
    @columns = make_columns(input)
  end

  def rows_before_mirror
    mirror_index = mirrored_index(true)
    return nil unless mirror_index
    mirror_index + 1
  end

  def columns_before_mirror
    mirror_index = mirrored_index(false)
    return nil unless mirror_index
    mirror_index + 1
  end

  def make_columns(input)
    columns = []

    rows[0].length.times do |column_index|
      column = []
      rows.length.times do |row_index|
        column << rows[row_index][column_index]
      end
      columns << column.join('')
      column = []
    end

    columns
  end

  def mirrored_index(with_rows = true)
    if with_rows
      lines = rows
    else
      lines = columns
    end

    # For each potential mirror index
    0.upto(lines.length - 2) do |index|
      current_row = lines[index]
      next_row = lines[index + 1]
      next if current_row != next_row

      offset = 1
      loop do
        earlier_row = positive_array_index(lines, index - offset)
        later_row = positive_array_index(lines, index + 1 + offset)

        # If we ran out of rows to compare
        unless earlier_row && later_row
          return index
        end

        offset += 1
        break if earlier_row != later_row
      end
    end

    return nil
  end

  def positive_array_index(array, index)
    return nil if index < 0
    array[index]
  end
end

grids = separate_grids(input)

sum = 0
grids.each do |grid|
  rows_before = grid.rows_before_mirror
  if rows_before
    sum += (100 * rows_before)
  else
    sum += grid.columns_before_mirror
  end
end

p sum # 31265