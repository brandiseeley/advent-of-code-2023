input = File.open('input.txt').readlines
# test = File.open('testinput.txt').readlines

def parse_races(input)
  time = input[0].split(' ')[1..-1].join('').to_i
  record = input[1].split(' ')[1..-1].join('').to_i

  return Race.new(time, record)
end

class Race
  def initialize(duration, record)
    @duration = duration
    @record = record
  end

  def race(charging_time)
    (@duration - charging_time) * charging_time
  end

  def ways_to_win()
    winning_charging_time_count = 0
    
    1.upto(@duration - 1) do |charging_time|
      if race(charging_time) > @record
        winning_charging_time_count += 1
      end
    end

    winning_charging_time_count
  end
end

race = parse_races(input)
p race.ways_to_win() # 35349468