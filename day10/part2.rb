=begin
--- Problem ---
Given a grid of pipes and non-pipes, where
 - | 7 F J L are all pipes and . is a non-pipe
and an S that represents a special point on the pipes

Figure out how many points are within the loop you've created

- The pipes connected to the S always make one continuous
  loop

--- Examples ---
. . F 7 .       7 - F 7 - 
. F J | .       . F J | 7
S J . L 7   ->  S J L L 7 < this example has extra pipe pieces
| F - - J       | F - - J
L J . . .       L J . L J

Above we have only 1 tile enclosed in our loop

. . . . . . . . . .
. S - - - - - - 7 .
. | F - - - - 7 | .
. | | O O O O | | .
. | | O O O O | | .
. | L - 7 F - J | .
. | I I | | I I | .
. L - - J L - - J .
. . . . . . . . . .

. . . . . . . . . .
. S - - - - - - 7 .
. | F - - - - 7 | .
. | | O O O O | | .
. | | O O O O | | .
. | L - 7 F - J | .
. | I I | | I I | .
. L - - J L - - J .
. . . . . . . . . .

For every loop, we can color in different sections. If we color in the
above section, we have 4 distinct touching 'spaces':

. . . . . . . . . .
. S - - - - - - 7 .
. | F - - - - 7 | .
. | | O O O O | | .
. | | O O O O | | .
. | L - 7 F - J | .
. | 1 1 | | 2 2 | .
. L - - J L - - J .
. . . . . . . . . .

Here we have the Os, the 1s and the 2s.

If we traverse the pipes, we will encircle each space. Spaces that are
within the loop will be encircled IN THE SAME DIRECTION as we are traversing
the loop. If we are stepping through our loop CLOCKWISE, then we are 
going to encircle the space CLOCKWISE if it's in the loop. Spaces that are
outside of the loop will be circled COUNTER-CLOCKWISE

SO LONG AS WE'RE MOVING CLOCKWISE:
This means that every pipe that we traverse that is next to a space will:
INSIDE THE LOOP: Move RIGHT TO LEFT when at the BOTTOM of the space
OUTSIDE OF THE LOOP: Move LEFT TO RIGHT at the bottom of the space

Cant tell which way is clockwise? Just split them up and try both answers
- one will be outside of structure, one will be inside

--- Data Structures ---

--- Algorithm ---

High Level:
- Traverse the loop and change all pipes to special characters
- Iterate over the map and turn all pipes that are left over to .
- COLOR THE MAP
  - set color to 1
  - Iterate over the tiles. 
    - If the current tile is part of our loop, do nothing
    - If the current tile is a blank space, do nothing (it's outside the loop)
    - If the current tiles is a '.', color this space.
      - Replace the dot with our current color. Check all neighbors.
      - Recursively color all touching neighbors with one
      - when we don't have any more to color, increment our color and keep going

     -1 0  

0 -1  0 0  0 1
   
      1 0

pipe above:
-  ...  
3

pipe below:
3
-

PUSHING COLORED SECTIONS INTO IN OR OUT
- Collect the coordinates of all '-'s that are in the loop, 
  named horizontal_pipe_coordinate

- Every section, to be a section, has to have |'s and -'s
- For any given section of color, iterate over it's coordinates until
  you find a coordinate that is either above or below a horizontal pipe.
  As soon as you find one,
  INSPECT THAT COORDINATE
  collect the two neighboring pipes. This gives us three pipe segments. 
  The center one, the one coming into that one and the one going out of that one
    - IF THE ORIGINAL PIPE IS ABOVE THE COLORED TILE:
      - If the indices of the 3 pipe pieces are INCREASING in regards to their
        placement in the loop_coordinates:
        
        THE PIPE IS MOVING CLOCKWISE AROUND THIS COLOR

      - If the indices of the 3 pipe pieces are DECREASING in regards to their
        placement in the loop_coordinates

        THE PIPE IS MOVING COUNTER-CLOCKWISE AROUND THIS COLOR

    - IF THE ORIGINAL PIPE IS BELOW THE COLORED TILE:
        - If the indices of the 3 pipe pieces are INCREASING in regards to their
        placement in the loop_coordinates:
        
        THE PIPE IS MOVING COUNTER-CLOCKWISE AROUND THIS COLOR

      - If the indices of the 3 pipe pieces are DECREASING in regards to their
        placement in the loop_coordinates

        THE PIPE IS MOVING CLOCKWISE AROUND THIS COLOR

    IF a color is begin circled clockwise, add it to the clockwise colors

    If a color is being circled counter-clockwise, add it to the counter-clockwise colors

=end

input = File.open('input.txt').readlines
# input = File.open('testinput.txt').readlines

DIFFERENCES = { 'up' => [-1, 0],
                'right' => [0, 1],
                'down' => [1, 0],
                'left' => [0, -1] }

PIPE_SYMBOLS = ['-', '|', 'T', 'J', 'F', 'L']

class Grid
  attr_reader :rows, :start, :current_location, :last_location, :steps_taken, :colors

  def initialize(input)
    @rows = input.map { |row| row.chomp.split('') }
    replace_7s
    @start = find_s_coordinate
    @current_location = nil
    @last_location = @start
    @steps_taken = 0
    @loop_coordinates = [@start]
    @colors = {}
    take_first_step
  end

  def replace_7s
    @rows.map!.with_index do |row, row_index|
      row.map!.with_index do |tile, column_index|
        if tile == '7'
          'T'
        else
          tile
        end
      end
    end
  end

  def find_s_coordinate
    rows.each_with_index do |row, row_index|
      row.each_with_index do |column, column_index|
        if rows[row_index][column_index] == 'S'
          return [row_index, column_index]
        end
      end
    end
  end

  def take_first_step
    @steps_taken += 1

    up = shift_coordinate('up', start)
    if in_grid?(up) && ['|', 'F', 'T'].include?(symbol_at_coordinate(up))
      @current_location = up
      return
    end

    right = shift_coordinate('right', start)
    if in_grid?(right) && ['-', 'J', 'T'].include?(symbol_at_coordinate(right))
      @current_location = right
      return
    end

    down = shift_coordinate('down', start)
    if in_grid?(down) && ['|', 'J', 'L'].include?(symbol_at_coordinate(down))
      @current_location = down
      return
    end

    left = shift_coordinate('left', start)
    if in_grid?(left) && ['-', 'L', 'T'].include?(symbol_at_coordinate(left))
      @current_location = left
      return
    end
  end

  def shift_coordinate(direction, coordinate)
    [coordinate[0] + DIFFERENCES[direction][0], coordinate[1] + DIFFERENCES[direction][1]]
  end

  def symbol_at_coordinate(coordinate)
    rows[coordinate[0]][coordinate[1]]
  end

  def in_grid?(coordinate)
    if coordinate[0] < 0 || coordinate[0] >= rows.length
      return false
    end

    if coordinate[1] < 0 || coordinate[1] >= rows[0].length
      return false
    end

    true
  end

  def step_forward
    @steps_taken += 1

    current_symbol = symbol_at_coordinate(current_location)

    next_spot = case current_symbol
    when '-'
      if last_location == shift_coordinate('left', current_location)
        shift_coordinate('right', current_location)
      else
        shift_coordinate('left', current_location)
      end
    when '|'
      if last_location == shift_coordinate('up', current_location)
        shift_coordinate('down', current_location)
      else
        shift_coordinate('up', current_location)
      end
    when 'J'
      if last_location == shift_coordinate('left', current_location)
        shift_coordinate('up', current_location)
      else
        shift_coordinate('left', current_location)
      end
    when 'T'
      if last_location == shift_coordinate('left', current_location)
        shift_coordinate('down', current_location)
      else
        shift_coordinate('left', current_location)
      end
    when 'L'
      if last_location == shift_coordinate('up', current_location)
        shift_coordinate('right', current_location)
      else
        shift_coordinate('up', current_location)
      end
    when 'F'
      if last_location == shift_coordinate('right', current_location)
        shift_coordinate('down', current_location)
      else
        shift_coordinate('right', current_location)
      end
    end

    @last_location = current_location
    @current_location = next_spot
  end

  def collect_loop_coordinates
    while (symbol_at_coordinate(current_location) != 'S')
      @loop_coordinates << current_location
      step_forward
    end
  end

  def color_non_pipes
    @rows.map!.with_index do |row, row_index|
      row.map!.with_index do |tile, column_index|
        if @loop_coordinates.include?([row_index, column_index])
          tile
        else
          '.'
        end
      end
    end
  end
  
  def color_section(coordinate, color)
    @rows[coordinate[0]][coordinate[1]] = color

    up = shift_coordinate('up', coordinate)
    right = shift_coordinate('right', coordinate)
    down = shift_coordinate('down', coordinate)
    left = shift_coordinate('left', coordinate)
    
    neighbors = [up, right, down, left].filter { |coordinate| in_grid?(coordinate) }
    
    neighbors.each do |neighbor|
      if symbol_at_coordinate(neighbor) == '.'
        @colors[color] << neighbor
        @rows[neighbor[0]][neighbor[1]] = color
        color_section(neighbor, color)
      end
    end
  end
  
  def color_sections
    current_color = 1
    rows.each_with_index do |row, row_index|
      row.each_with_index do |tile, column_index|
        current_coordinate = [row_index, column_index]
        if symbol_at_coordinate(current_coordinate) == '.'
          @colors[current_color] = [current_coordinate]
          color_section(current_coordinate, current_color)
          current_color += 1
        end
      end
    end

    @number_of_colors = current_color
  end

  def divide_sections
    clockwise = []
    counter_clockwise = []

    1.upto(@number_of_colors - 1) do |current_color|
      color_coordinates = @colors[current_color]

      on_edge = (color_coordinates.any? do |coordinate|
        # if it's on the edge
        if coordinate[0] == 0 || coordinate[0] == (@rows.length - 1)
          true
        elsif coordinate[1] == 0 || coordinate[1] == (@rows[0].length - 1)
          true
        else
          false
        end
      end)

      if on_edge
        next
      end

      next_to_pipe = nil
      pipe_coordinate = nil
      color_coordinates.each do |color_coordinate|
        up = shift_coordinate('up', color_coordinate)
        if in_grid?(up) && PIPE_SYMBOLS.include?(symbol_at_coordinate(up))
          next_to_pipe = color_coordinate
          pipe_coordinate = up
          break
        end

        down = shift_coordinate('down', color_coordinate)
        if in_grid?(down) && PIPE_SYMBOLS.include?(symbol_at_coordinate(down))
          next_to_pipe = color_coordinate
          pipe_coordinate = down
          break
        end

        break if pipe_coordinate
      end

      # What if this isn't a pipe????
      index_of_main_pipe = @loop_coordinates.index(pipe_coordinate)
      pipe_symbol = symbol_at_coordinate(pipe_coordinate)
      next_pipe_coordinate = nil
      pipe_above_color = true

      # If our pipe is ABOVE our color
      if pipe_coordinate[0] < next_to_pipe[0]
        if pipe_symbol == '-' || pipe_symbol == 'L'
          next_pipe_coordinate = [pipe_coordinate[0], pipe_coordinate[1] + 1]
        else
          next_pipe_coordinate = [pipe_coordinate[0] - 1, pipe_coordinate[1]]
        end
      else # If our pipe is BELOW our color
        pipe_above_color = false
        if pipe_symbol == 'F' || pipe_symbol == 'T'
          next_pipe_coordinate = [pipe_coordinate[0] + 1, pipe_coordinate[1]]
        else
          next_pipe_coordinate = [pipe_coordinate[0], pipe_coordinate[1] + 1]
        end
      end

      indices_of_pipes = [@loop_coordinates.index(pipe_coordinate), @loop_coordinates.index(next_pipe_coordinate)]

      # If the pipe is ABOVE the colored tile
      if pipe_above_color

        # if the indices are increasing
        if indices_of_pipes[0] < indices_of_pipes[1]
          counter_clockwise << current_color
        else
          clockwise << current_color
        end

      else # If the pipe is BELOW the colored tile
        # if the indices are increasing
        if indices_of_pipes[0] < indices_of_pipes[1]
          clockwise << current_color
        else
          counter_clockwise << current_color
        end
      end

    end

    [clockwise, counter_clockwise]
  end

  
  def main
    collect_loop_coordinates
    color_non_pipes
    color_sections

    sections = divide_sections

    section_a = sections[0]
    section_a_tile_count = 0
    section_a.each do |color|
      section_a_tile_count += @colors[color].length
    end

    section_b = sections[1]
    section_b_tile_count = 0
    section_b.each do |color|
      section_b_tile_count += @colors[color].length
    end

    p [section_a_tile_count, section_b_tile_count]
  end

  def to_s
    str = ''
    rows.each do |row|
      rowstr = ''
      row.each do |symbol|
        rowstr << " #{symbol}"
      end
      str << rowstr + "\n"
    end
    str
  end
end

grid = Grid.new(input)
# More work required to figure out which number is inside count vs outside count. In retrospect, would've divvied up groups differently
grid.main # 298, 415