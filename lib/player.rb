class HumanPlayer
  def initialize(name)
    @name = name
  end

  def get_play
    guess = []
    puts "Enter the coordinate you wish to fire on."
    guess = gets.chomp.split(",").map { |el| Integer(el) }

    if guess.length != 2
      guess = nil
      get_play
    end

    guess
  end
end
