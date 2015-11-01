require_relative "board"
require_relative "battleship"

class ComputerPlayer
  def initialize(name)
    @name = name
    @previous_shots = []
  end

  def get_play
    guess = [rand(10), rand(10)]

    while @previous_shots.include?(guess)
      guess = [rand(10), rand(10)]
    end
    @previous_shots << guess
    guess
  end
end
