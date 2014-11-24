require_relative 'piece.rb'
require_relative 'sliding.rb'

class Queen < Piece
  include Sliding

  def move_dir
    sideways + diagonal
  end

  def render
    color == :white ? '♕' : "♛"
  end

end
