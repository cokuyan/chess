require_relative 'piece.rb'
require_relative 'sliding.rb'

class Bishop < Piece
  include Sliding

  def move_dir
    diagonal
  end

  def symbol
    color == :white ? '♗' : "♝"
  end

end
