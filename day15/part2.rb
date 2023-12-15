=begin
--- Problemn ---
- 256 BOXES - labeled 0-255
  - Boxes stay in order
- Each box has lense slots
  - lenses keep order
  - Lenses have a focal length from 1-9
- INPUT
  - Each part is instructions.
    - The letters at the beginning are the LABEL
      for the lense
    - Running our hash algorithm from part one on
      that label gives us the correct box for that
      step
    - The OPERATION is the character after the letter
        - = or -
    - DASH -
        - Go to the given box and remove the
          lens with the given label IF IT IS PRESENT
        - Move any lenses forward to eliminate the gap
        - If lense isn't there, nothing happens
    - EQUAL =
        - Equals are followed by a number indicating
          the focal length of the lense to be used
        - Label the lense so you know the focal length
        - IF THE BOX ALREADY HAS A LENSE WITH self LABEL
          - replace it with the new lense (change the label on old)
        - IF IT ISN'T IN THE BOX,
          - Add self lense to the back
=end

input = File.open('input.txt').readlines(chomp: true)
# input = File.open('testinput.txt').readlines(chomp: true)
require_relative './part1.rb'

class Box
  attr_accessor :lenses

  def initialize
    self.lenses = []
  end

  def remove_lense(target_lense)
    lenses.filter! do |lense|
      lense.label != target_lense.label
    end
  end

  def add_lense(lense)
    matching_lenses = lenses.filter { |existing_lense| existing_lense.label == lense.label }
    if matching_lenses.length > 0
      matching_lenses[0].focal_length = lense.focal_length
    else
      lenses << lense
    end
  end

  def to_s
    lense_string = ''
    lenses.each do |lense|
      lense_string += "[ #{lense.label} #{lense.focal_length} ]"
    end

    lense_string
  end
end

class Lense
  attr_accessor :label, :focal_length

  def initialize(label, focal_length)
    self.label = label
    self.focal_length = focal_length
  end
end

def make_boxes
  boxes = []

  256.times do
    boxes << Box.new
  end

  boxes
end

def print_boxes(boxes)
  boxes.each_with_index do |box, index|
    puts "Box #{index}: #{box}"
  end
end

boxes = make_boxes
instructions = input[0].split(',')

instructions.each do |string|
  # remove lense
  if string.include?('-')
    parts = string.split('-')
    box_index_operate_on = transform(parts[0])
    lense = Lense.new(parts[0], nil)

    boxes[box_index_operate_on].remove_lense(lense)
  # add lense
  else
    parts = string.split('=')
    box_index_operate_on = transform(parts[0])
    lense = Lense.new(parts[0], parts[1])

    boxes[box_index_operate_on].add_lense(lense)
  end
end

# print_boxes(boxes)

focusing_power = 0
boxes.each_with_index do |box, box_number|
  box_total = 0
  box.lenses.each_with_index do |lense, lense_position|
    box_total += ((1 + box_number) * (lense_position + 1) * lense.focal_length.to_i )
  end

  focusing_power += box_total
end

p focusing_power # 261505