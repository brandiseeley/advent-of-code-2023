=begin
--- Problem ---
RACE:
  STATES:
  - Duration - How long the race lasts
  - Record - Record for how far a competitor has ever gone

  BEHAVIORS:
  - race(duration, charging_time) -> returns a distance that a boat would make it with given chargin time and duration
    time to travel = duration - charging_time
    return time_to_travel * boat_speed (which is equal to charging time)

    (duration - charging_time) * charging_time

--- Examples ---

RACE: Duration: 7, Record: 9
  race(7, 0) = 0 -> (7-0)*0
  race(7, 1) = 6
  race(7, 2) = 10
  race(7, 3) = 12
  race(7, 4) = 12
  race(7, 5) = 10
  race(7, 6) = 6
  race(7, 7) = 0

  Charging times of 2, 3, 4, 5 all beat the record, giving us **4 WAYS TO WIN**


For several races, mutliply together how many ways there are to win each race.

--- Data Structures ---

--- Algorithm ---
=end

input = File.open('input.txt').readlines
# test = File.open('testinput.txt').readlines

def parse_races(input)
  times = input[0].split(' ')[1..-1].map(&:to_i)
  records = input[1].split(' ')[1..-1].map(&:to_i)

  races = []
  times.each_with_index do |duration, index|
    races << Race.new(duration, records[index])
  end
  races
end

class Race
  def initialize(duration, record)
    @duration = duration
    @record = record
  end

  def race(charging_time)
    (@duration - charging_time) * charging_time
  end

  def ways_to_win
    winning_charging_time_count = 0
    1.upto(@duration - 1) do |charging_time|
      if race(charging_time) > @record
        winning_charging_time_count += 1
      end
    end

    winning_charging_time_count
  end

end

def multiply_winning_combinations(races)
  ways_to_win = []

  races.each do |race|
    ways_to_win << race.ways_to_win
  end

  ways_to_win.reduce(&:*)
end

races = parse_races(input)
p multiply_winning_combinations(races) # 1710720