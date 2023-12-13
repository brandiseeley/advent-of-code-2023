=begin
--- Problem ---
- Now, we realize that each mirror has a DIFFERENT reflection line. One that can be created by
  changing exactly one . to a # or # to a period

- Instead of checking for EXACTNESS, count the differences?
- set a differences = 0
- Iterate over each pair of lines, and find out how many differences there are between the rows
- Add these differences to differences
- If differences ever goes over 1, go to the next set
- If we make it to the end, make sure differences is exactly 1
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
    mirror_index = mirrored_index_with_smudge(with_rows = true)
    return nil unless mirror_index
    mirror_index + 1
  end

  def columns_before_mirror
    mirror_index = mirrored_index_with_smudge(with_rows = false)
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

  # Returns number of differences between two strings, unless there are more then 1, then we return nil
  def zero_one_or_more_differences(string1, string2)
    sum = 0

    string1.split('').each_with_index do |string1_char, index|
      sum += 1 if string1_char != string2[index]
      return nil if sum > 1
    end

    sum
  end

  def mirrored_index_with_smudge(with_rows = true)
    lines = with_rows ? rows : columns

    0.upto(lines.length - 2) do |index|
      differences = 0

      current_row = lines[index]
      next_row = lines[index + 1]

      differences_for_current_line = zero_one_or_more_differences(current_row, next_row)
      next unless differences_for_current_line
      differences += differences_for_current_line
      next unless differences < 2

      # Compare rows expanding away from our matching or almost matching rows
      offset = 1
      loop do
        earlier_row = positive_array_index(lines, index - offset)
        later_row = positive_array_index(lines, index + 1 + offset)

        # If we ran out of rows to compare
        unless earlier_row && later_row
          # We have to have one difference (Otherwise this is the mirror index for part 1)
          if differences == 1
            return index
          else
            break
          end
        end

        offset += 1

        # Compare the two rows
        differences_for_current_line = zero_one_or_more_differences(earlier_row, later_row)
        break unless differences_for_current_line
        differences += differences_for_current_line
        break if differences > 1
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

p sum # 39359