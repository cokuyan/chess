require_relative 'piece.rb'
require_relative 'sliding.rb'

class Bishop < Piece
  include 'sliding'

  def move_dir
    diagonal
  end

  def render
    color == :white ? '♗' : "♝"
  end

end
