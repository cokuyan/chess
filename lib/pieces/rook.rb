require_relative 'piece.rb'
require_relative 'sliding.rb'

class Rook < Piece
  include Sliding

  def initialize(pos, board, color, has_moved = false)
    super(pos, board, color)
    @has_moved = has_moved
  end

  def symbol
    color == :white ? '♖' : "♜"
  end

  def has_moved?
    @has_moved
  end

  def move(end_pos)
    @has_moved = true
    super
  end

  def move_dir
    sideways
  end

end
