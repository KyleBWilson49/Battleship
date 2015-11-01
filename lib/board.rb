class Board
  DISPLAY_HASH = {
    nil => " ",
    :s => " ",
    :x => "x"
  }
  DISPLAY_PLAYER = {
    nil => " ",
    :s => "s",
    :x => "x"
  }
  SHIPS_HASH = {
    :aircraft_carrier => 5,
    :battleship => 4,
    :submarine => 3,
    :destroyer => 3,
    :patrol_boat => 2
  }

  def self.default_grid
    Array.new(10) { Array.new(10) }
  end

  attr_accessor :grid

  def initialize(grid = self.class.default_grid)
    @grid = grid
    place_ships
  end

  def place_ships
    placement_method = get_method

    if placement_method == 0
      self.randomize
    elsif placement_method == 1
      system("clear")
      place_real_ships
    elsif placement_method == 2
    #  system("clear")
      puts "Not ready for use. Please try agian later."
      place_ships
    else
      place_ships
    end
  end

  def get_method
    system('clear')
    puts "How would you like your ships:"
    puts "Random point ships (press 0)"
    puts "Random ships of 5 sizes (press 1)"
    puts "Place your own ships (press 2)"
    placement_method = gets.to_i
  end

  def randomize(count = 10)
    count.times { place_random_ship }
  end

  def place_random_ship
    raise "hell" if full?
    pos = random_pos

    until empty?(pos)
      pos = random_pos
    end

    self[pos] = :s
  end

  def place_real_ships
    SHIPS_HASH.each do |ship, length|
      pos = get_free_postion
      direction = random_direction

      until valid_placement?(pos, direction, length)
        pos = get_free_postion
        direction = random_direction
      end

      place_real_ship(pos, direction, length)
    end
  end

  def place_real_ship(pos, direction, length)
    x = pos[0]
    y = pos[1]

    (0..length - 1).each do |move|
      if direction == 0
        pos = [x + move, y]
      elsif direction == 1
        pos = [x, y + move]
      elsif direction == 2
        pos = [x - move, y]
      else
        pos = [x, y - move]
      end
      self[pos] = :s
    end
  end

  def valid_placement?(pos, direction, length)
    x = pos[0]
    y = pos[1]

    (0...length).each do |move|
      if direction == 0
        pos = [x + move, y]
      elsif direction == 1
        pos = [x, y + move]
      elsif direction == 2
        pos = [x - move, y]
      else
        pos = [x, y - move]
      end
      return false unless in_range?(pos) && empty?(pos)
    end

  end

  def get_free_postion
    pos = random_pos
    until empty?(pos)
      pos = random_pos
    end
    pos
  end

  def random_direction
    rand(4)
  end

  def random_pos
    [rand(size), rand(size)]
  end

  def empty?(pos = nil)
    if pos
      self[pos].nil?
    else
      count == 0
    end
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos, val)
    x, y = pos
    grid[x][y] = val
  end

  def count
    grid.flatten.select { |el| el == :s }.length
  end

  def display_ai
    header = (0..9).to_a.join("  ")
    p "  #{header}"
    grid.each_with_index { |row, i| display_ai_row(row, i) }
  end

  def display_ai_row(row, i)
    chars = row.map { |el| DISPLAY_HASH[el] }.join("  ")
    p "#{i} #{chars}"
  end

  def display_player
    header = (0..9).to_a.join("  ")
    p "  #{header}"
    grid.each_with_index { |row, i| display_player_row(row, i) }
  end

  def display_player_row(row, i)
    chars = row.map { |el| DISPLAY_PLAYER[el] }.join("  ")
    p "#{i} #{chars}"
  end

  def full?
    grid.flatten.none?(&:nil?)
  end

  def in_range?(pos)
    pos.all? { |x| x.between?(0, grid.length - 1) }
  end

  def size
    grid.length
  end

  def won?
    grid.flatten.none? { |el| el == :s }
  end
end
