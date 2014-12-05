require_relative 'pieces.rb'
require_relative 'errors.rb'

class Board

  attr_accessor :taken_pieces

  def initialize(setup = true)
    @board = Array.new(8) {Array.new(8)}
    @taken_pieces = []
    initialize_sides if setup
  end

  def [](pos)
    raise "not on board" unless on_board?(pos)

    x,y = pos
    @board[x][y]
  end

  def []=(pos, value)
    raise "not on board" unless on_board?(pos)

    x,y = pos
    @board[x][y] = value
  end

  def on_board?(pos)
    pos.all? { |el| el.between?(0,7) }
  end

  def move_piece(start, end_pos)
    piece = self[start]
    taken_piece = self[end_pos]

    raise PieceSelectionError if piece.nil?
    raise InCheckError if piece.move_into_check?(end_pos)
    raise InvalidMoveError unless piece.valid_moves.include?(end_pos)

    # make King#maybe_castle instead?
    piece.castle if piece.is_a?(King) && (end_pos[1] - start[1]).abs == 2
    move_piece!(start, end_pos)
    taken_pieces << taken_piece if taken_piece
  end

  def move_piece!(start, end_pos)
    piece = self[start]
    piece.move(end_pos)
  end

  def dup
    dupped_board = Board.new(false)
    @board.flatten.compact.each { |piece| piece.dup(dupped_board) }
    dupped_board
  end

  # need to refactor
  def render
    "   " + ('A'..'H').to_a.join("   ") + "\n" +
    " ┌" + ("───┬" * 7) + "───┐" + "\n" +
    @board.map.with_index do |row, index|
      section = ((8 - index).to_s +
      row.map do |square|
        square.nil? ? "│   " : "│ #{square.render} "
      end.join +
      "│" + (8-index).to_s + "\n")
      index == 7 ? section : section + " ├" + ("───┼" * 7) + "───┤" + "\n"
    end.join +
    " └" + ("───┴" * 7) + "───┘" + "\n" +
    "   " + ('A'..'H').to_a.join("   ")
  end

  def stalemate?(color)
    return false if checkmate?(color)
    all_valid_moves(color).empty?
  end

  def checkmate?(color)
    return false unless in_check?(color)
    all_valid_moves(color).empty?
  end

  def in_check?(color)
    king = find_king(color)
    all_moves(enemy_color(color)).include?(king.pos)
  end

  def all_pieces(color)
    @board.flatten.compact.select { |piece| piece.color == color }
  end


  private

  def find_king(color)
    all_pieces(color).select { |piece| piece.is_a?(King) }.first
  end

  def enemy_color(color)
    color == :white ? :black : :white
  end

  def all_moves(color)
    all_moves = []
    all_pieces(color).each { |piece| all_moves += piece.moves }
    all_moves.uniq
  end

  def all_valid_moves(color)
    all_valid_moves = []
    all_pieces(color).each { |piece| all_valid_moves += piece.valid_moves }
    all_valid_moves.uniq
  end

  def initialize_sides
    initialize_pieces(:white)
    initialize_pieces(:black)
  end

  def initialize_pieces(color)
    row = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    back_row, front_row = (color == :white ? [7,6] : [0,1])

    8.times { |col| Pawn.new([front_row, col], self, color) }

    row.each_with_index do |piece, col|
      piece.new([back_row, col], self, color)
    end
  end

end
