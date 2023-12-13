input = File.open('input.txt').readlines
# input = File.open('testinput.txt').readlines

class Grid
  attr_reader :rows

  def initialize(input)
    @rows = parse_input(input)
    find_empty_rows_and_columns
  end

  MULTIPLIER = 999999

  def sum_paths
    collect_row_and_column_indices
    sum = 0

    @row_indices.each_with_index do |row_index_a, main_index|
      column_index_a = @column_indices[main_index]

      main_index.upto(@row_indices.length - 1).each do |inner_index|
        next if inner_index == main_index

        row_index_b = @row_indices[inner_index]
        column_index_b = @column_indices[inner_index]

        row_expansions_covered = @row_indices_to_expand.count { |i| i.between?(*[row_index_a, row_index_b].sort) }
        column_expansions_covered = @column_indices_to_expand.count { |i| i.between?(*[column_index_a, column_index_b].sort)  }

        sum += ((row_index_a - row_index_b) + (row_expansions_covered * MULTIPLIER))
        sum += ((column_index_a - column_index_b).abs + (column_expansions_covered * MULTIPLIER))
      end
    end
    sum
  end

  private

  def collect_row_and_column_indices
    @row_indices = []
    @column_indices = []

    rows.each_with_index do |row, row_index|
      row.each_with_index do |tile, column_index|
        if tile == '#'
          @row_indices << row_index
          @column_indices << column_index
        end
      end
    end
  end

  def find_empty_rows_and_columns
    @row_indices_to_expand = []
    rows.each_with_index do |row, index|
      if row.all? { |tile| tile == '.' }
        @row_indices_to_expand << index
      end
    end

    @column_indices_to_expand = []
    each_column_with_index do |column, index|
      if column.all? { |tile| tile == '.' }
        @column_indices_to_expand << index
      end
    end
  end

  def parse_input(input)
    rows = []
    input.each { |line| rows << line.chomp.split('') }
    rows
  end

  def each_column_with_index
    rows[0].length.times do |column_index|
      column = []
      rows.length.times do |row_index|
        column << rows[row_index][column_index]
      end
      yield(column, column_index)
      column = []
    end
  end

  def to_s
    str = ''
    rows.each { |row| str << row.to_s + "\n" }
    str
  end
end

grid = Grid.new(input)
p grid.sum_paths # 650672493820