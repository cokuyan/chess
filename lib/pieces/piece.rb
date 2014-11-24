# encoding: utf-8

class Piece
  attr_writer :pos, :has_moved
  attr_reader :pos, :color


  def initialize(pos, board, color, has_moved = false)
    @pos, @board, @color = pos, board, color

    #piece places self
    @board[@pos] = self
    @has_moved = has_moved # may change
  end

  def moves
    raise NotImplementedError
    # return array of places can move
  end

  def has_moved?
    @has_moved
  end

  def dup(board)
    self.class.new(@pos, board, @color)
  end
############################################
  def move_into_check?(pos)
    test_board = @board.dup
    p test_board[self.pos].class
    p self.pos
    p pos
    test_board.move!(self.pos, pos)
    test_board.in_check?(self.color)
  end
############################################

  def valid_moves
    self.moves.reject { |move| move_into_check?(move) }
  end

  protected

  def is_enemy?(piece)
    self.color != piece.color
  end

  def add_arrays(arr1, arr2)
    arr1.zip(arr2).map { |el| el.inject(:+) }
  end

end
