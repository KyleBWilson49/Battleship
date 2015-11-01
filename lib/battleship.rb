require 'byebug'

require_relative "board"
require_relative "player"
require_relative "computer_player"

class BattleshipGame
  attr_reader :current_board, :current_player
  attr_accessor :board1, :board2

  def initialize(player1, player2, board1 = Board.new, board2 = Board.new)
    @player1 = player1
    @player2 = player2
    @board1 = board1
    @board2 = board2
    @current_player = player1
    @current_board = board2
    @hit = false
    @turns = 0
  end

  def play
    play_turn until game_over?
    declare_winner
  end

  def play_turn
    pos = nil

    until valid_play?(pos)
      display_status
      pos = @current_player.get_play
    end

    attack(pos)

    @turns += 1
    switch_players!
  end

  def switch_players!
    @current_player = @current_player == @player1 ? @player2 : @player1
    @current_board = @current_board == @board1 ? @board2 : @board1
  end

  def attack(pos)
    if @current_board[pos] == :s
      @hit = true
    else
      @hit = false
    end

    @current_board[pos] = :x
  end

  def game_over?
    @current_board.won?
  end

  def hit?
    @hit
  end

  def declare_winner
    if @current_player == @player1
      puts "You won!"
    elsif @current_player == @player2
      puts "You lost!"
    end
  end

  def valid_play?(pos)
    pos.is_a?(Array) && @current_board.in_range?(pos)
  end

  def display_status
    system("clear")
    @board2.display_ai
    puts "________________________________"
    puts "________________________________"
    @board1.display_player
    puts "#{@turns / 2} turns taken"
    puts "It is a HIT!" if hit?
    puts "There are #{@board2.count} ships remaining."
  end

  def count
    @current_board.count
  end
end

if $PROGRAM_NAME == __FILE__
  jane = HumanPlayer.new('jane')
  alice = HumanPlayer.new('Alice')
  ai1 = ComputerPlayer.new('AI')
  ai2 = ComputerPlayer.new('AI')
  game = BattleshipGame.new(jane, ai2)
  game.play
end
