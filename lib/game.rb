require 'yaml'
require_relative 'board.rb'

class Game

  attr_reader :board

  def initialize(white, black, board = Board.new)
    @white, @black, @board = white, black, board
    @current_player = @white
  end

  def run
    until over?
      begin
        puts @board.taken_pieces.select{|piece| piece.color ==  :white}.map(&:render).join(" ")
        board.render
        puts @board.taken_pieces.select{|piece| piece.color == :black}.map(&:render).join(" ")
        puts "#{@current_player.color.to_s.capitalize}'s turn"
        puts "You are in check" if board.in_check?(@current_player.color)

        start, end_pos = @current_player.get_move(@board)
        if start == :save
          save_game
          redo
        elsif start == :quit
          return
        end
        @board.move_piece(start, end_pos)
        # check for pawn promotion
        piece = @board[end_pos]
        @current_player.promote(piece) if piece.is_a?(Pawn) && [0,7].include?(end_pos[0])

        switch_player
      rescue ChessError => e
        puts e.message
        retry
      end
    end

    @board.render
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
    @board.checkmate?(@current_player.color) ||
    @board.stalemate?(@current_player.color)
  end

  def end_game
    if @board.stalemate?(@current_player.color)
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

  def get_move(board)
    @board = board
    @board.render
    puts "#{@color.to_s.capitalize}'s turn"
    puts "You are in check" if @board.in_check?(@color)
    puts
    puts "Enter piece to move, 'save' to save, or 'quit' to quit"

    start = gets.chomp.downcase
    return start.to_sym if start == "save" || start == "quit"

    start = start.split('')
    puts "Where would you like to move it?"
    end_pos = gets.chomp.split('')
    start, end_pos = convert(start), convert(end_pos)

    raise EnemyPieceError if @board[start] &&
                             @board[start].color != self.color

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
    @board[pawn.pos] = nil
    response.new(pawn.pos, @board, pawn.color, true)
  end

end

class ComputerPlayer

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def promote(pawn)
    @board[pawn.pos] = nil
    Queen.new(pawn.pos, @board, pawn.color, true)
  end

  def get_move(board)
    @board = board

    while true
      piece = board.all_pieces(color).sample
      move = piece.valid_moves.sample
      break unless move.nil?
    end
    sleep 1
    [piece.pos, move]
  end

end
