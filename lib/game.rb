require 'yaml'
require_relative 'board.rb'

class EnemyPieceError < ChessError
  def message
    "You chose an enemy piece!"
  end
end

class Game

  attr_reader :game_board

  def initialize(white, black, board = nil)
    @white, @black = white, black
    board ||= Board.new
    @game_board = board
    @current_player = @white
  end

  def run

    until over?
      begin
        start, end_pos = @current_player.get_move(@game_board)
        if start == :save
          save_game
          redo
        elsif start == :quit
          return
        end
        @game_board.move_piece(start, end_pos)
        piece = @game_board[end_pos]
        @current_player.promote(piece) if piece.is_a?(Pawn) && [0,7].include?(end_pos[0])
        switch_player

      rescue ChessError => e
        puts e.message
        retry
      end
    end

    end_game
  end

  def save_game
    puts "Enter a file name for the saved game"
    file_name = gets.chomp
    File.open(file_name, 'w') do |file|
      file.puts self.to_yaml
    end
  end

  private

  def over?
    @game_board.checkmate?(@current_player.color) ||
    @game_board.stalemate?(@current_player.color)
  end

  def end_game
    # current player is in checkmate
    if @game_board.stalemate?(@current_player.color)
      puts "Stalemate"
    else
      switch_player

      puts "Congratulations, #{@current_player.color.to_s.capitalize}!"
      puts "You won!"
    end
  end


  def switch_player
    @current_player = @current_player == @white ? @black : @white
  end


end

class HumanPlayer

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def get_move(game_board)
    @game_board = game_board
    @game_board.render
    puts "#{@color.to_s.capitalize}'s turn"
    puts "You are in check" if @game_board.in_check?(@color)
    puts
    puts "Enter 'save' to save, 'quit' to quit"
    puts "Press any key to continue"

    response = gets.chomp.downcase
    return response.to_sym if response == "save" || response == "quit"

    puts "Which piece would you like to move?"
    start = gets.chomp.split('')
    puts "Where would you like to move it?"
    end_pos = gets.chomp.split('')
    start, end_pos = convert(start), convert(end_pos)

    raise EnemyPieceError if @game_board[start] &&
                             @game_board[start].color != self.color

    [start, end_pos]
  end

  def convert(position)
    first = position[0].ord - 'a'.ord
    second = 8 - position[1].to_i

    [second, first]
  end

  def promote(pawn)
    puts 'What would you like to promote your pawn to?'
    begin
      response = Object.const_get(gets.chomp.capitalize)
      if [King, Pawn].include?(response)
        raise PromotionError.new("Cannot promote to #{response}")
      end
    rescue PromotionError => e
      puts e.message
      retry
    end
    @game_board[pawn.pos] = nil
    response.new(pawn.pos, @game_board, pawn.color, true)
  end

end

class ComputerPlayer

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def promote(pawn)
    @game_board[pawn.pos] = nil
    Queen.new(pawn.pos, @game_board, pawn.color, true)
  end

  def get_move(game_board)
    @game_board = game_board

    game_board.render
    puts "#{@color.to_s.capitalize}'s turn"
    puts "You are in check" if game_board.in_check?(@color)

    while true
      piece = game_board.all_pieces(color).sample

      move = piece.valid_moves.sample

      break unless move.nil?
    end
    sleep 1
    [piece.pos, move]
  end

end
