=begin
--- Problem ---
- Given a grid, expand the grid based on these rules:
  - Any row that doesn't contain a `#` should be duplicated
  - any column that doesn't contain a '#' should be duplicated

- With the resulting grid, return the sum of the shortest path
  betweene each pair of '#'. The shortest path is just the difference
  in x plus the difference in y.  
--- Examples ---

...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....

expands to...

....1........
.........2...
3............
.............
.............
........4....
.5...........
............6
.............
.............
.........7...
8....9.......

Smaller example:
....1........
.........2...
3............
.............
.............
........4....

#...
..#.
....

Path from galaxy 3 to :
1: 6
2: 10 -> all sum to 27
4: 11

We can split this up into y's and x's
galaxy xs (row index) : [0, 1, 2, 5] 
galaxy ys (col index) : [4, 9, 0, 8]
                               ^
From 3: xs=(2 + 1 + 3) ys=(4 + 9 + 8) = 27

--- Data Structures ---

Grid to Expand


--- Algorithm ---

=end

# input = File.open('input.txt').readlines
input = File.open('testinput.txt').readlines

class Grid
  attr_reader :rows

  def initialize(input)
    @rows = parse_input(input)
    expand_grid
  end

  def sum_paths
    collect_row_and_column_indices
    sum = 0

    @row_indices.each_with_index do |row_index_of_galaxy, main_index|
      column_index_of_galaxy = @column_indices[main_index]

      main_index.upto(@row_indices.length - 1).each do |inner_index|
        next if inner_index == main_index
        sum += (row_index_of_galaxy - @row_indices[inner_index]).abs
        sum += (column_index_of_galaxy - @column_indices[inner_index]).abs
      end
    end
    p sum
  end

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

  def expand_grid
    row_indices_to_expand = []
    rows.each_with_index do |row, index|
      if row.all? { |tile| tile == '.' }
        row_indices_to_expand << index
      end
    end

    column_indices_to_expand = []
    each_column_with_index do |column, index|
      if column.all? { |tile| tile == '.' }
        column_indices_to_expand << index
      end
    end

    row_indices_to_expand.reverse.each do |row_index|
      blank_row = Array.new(rows[0].length, '.')
      rows.insert(row_index, blank_row)
    end

    column_indices_to_expand.reverse.each do |column_index|
      rows.length.times do |row_index|
        rows[row_index].insert(column_index, '.')
      end
    end
  end

  def parse_input(input)
    rows = []
    input.each do |line|
      rows << line.chomp.split('')
    end

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
grid.sum_paths