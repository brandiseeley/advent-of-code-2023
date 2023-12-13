=begin
--- Problem ---
Given a grid of pipes and non-pipes, where
 - | 7 F J L are all pipes and . is a non-pipe
and an S that represents a special point on the pipes
Figure out the point farthest from the S that is still on
the loop created by the pipes connected to the S

- The pipes connected to the S always make one continuous
  loop

- The distance farthest from the S is counted by how many
  pieces of pipe you have to traverse to get there

--- Examples ---
. . F 7 .       7 - F 7 - 
. F J | .       . F J | 7
S J . L 7*   ->  S J L L 7 < this example has extra pipe pieces
| F - - J       | F - - J
L J . . .       L J . L J

Above we have on the left only the pipes that are connected
to our main loop. The right is something like what we would start with

Since this main loop is 16 pieces total, the part furthest
from the S is 8 steps away

--- Data Structures ---

GRID

WALKER?
  current location
  previous location
  step forward
  steps taken

--- Algorithm ---

High Level:
- Traverse along The pipes, starting at S, counting the number
  of steps until we get back to S. S dividied by 2 is the answer

- S will always only have two connecting pipes in its direction

Low Level:
- Find S
- Find pipes connected to S, pick one as starting point
- Traverse the Pipes
  - From a given point, valid connecting pipes are:
    ABOVE: | F 7
    RIGHT: - 7 J
    BELOW: | J L
    LEFT:  - L F
- For each pipe on our loop, there will always be TWO of these 'valid pipes'
  present of the 4 squares
- Move forward to the one that is NOT where we came from
- Count one step
- When we end up back at our S, number of steps is what we use to 
  get the answer

     -1 0  

0 -1  0 0  0 1
   
      1 0

=end

input = File.open('input.txt').readlines
# input = File.open('testinput.txt').readlines

DIFFERENCES = { 'up' => [-1, 0],
                'right' => [0, 1],
                'down' => [1, 0],
                'left' => [0, -1] }

class Grid
  attr_reader :rows, :start, :current_location, :last_location, :steps_taken

  def initialize(input)
    @rows = input.map { |row| row.chomp.split('') }
    @start = find_s_coordinate
    @current_location = nil
    @last_location = @start
    @steps_taken = 0
    take_first_step
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
    if in_grid?(up) && ['|', 'F', '7'].include?(symbol_at_coordinate(up))
      @current_location = up
      return
    end

    right = shift_coordinate('right', start)
    if in_grid?(right) && ['-', 'J', '7'].include?(symbol_at_coordinate(right))
      @current_location = right
      return
    end

    down = shift_coordinate('down', start)
    if in_grid?(down) && ['|', 'J', 'L'].include?(symbol_at_coordinate(down))
      @current_location = down
      return
    end

    left = shift_coordinate('left', start)
    if in_grid?(left) && ['-', 'L', '7'].include?(symbol_at_coordinate(left))
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
    when '7'
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

  def complete_loop
    while (symbol_at_coordinate(current_location) != 'S')
      step_forward
    end
  end

  def farthest_step_from_s
    complete_loop
    steps_taken / 2
  end

  def to_s
    str = ''
    rows.each { |row| str << row.to_s + "\n" }
    str
  end
end

grid = Grid.new(input)
p grid.farthest_step_from_s # 6823