# encoding: utf-8

class Piece
  attr_accessor :pos
  attr_reader :color

  def initialize(pos, board, color, has_moved = false)
    @pos, @board, @color = pos, board, color
    @board[@pos] = self
  end

  def moves
    raise NotImplementedError
  end

  def has_moved?
    @has_moved
  end

  def dup(board)
    self.class.new(@pos, board, @color, has_moved?)
  end

  def move_into_check?(pos)
    test_board = @board.dup
    test_board.move_piece!(self.pos, pos)
    test_board.in_check?(self.color)
  end

  def valid_moves
    self.moves.reject { |move| move_into_check?(move) }
  end

  def move(end_pos)
    @board[pos] = nil
    @board[end_pos] = self
    @pos = end_pos
  end

  protected

  def is_enemy?(piece)
    self.color != piece.color
  end

  def add_arrays(arr1, arr2)
    arr1.zip(arr2).map { |el| el.inject(:+) }
  end


end
