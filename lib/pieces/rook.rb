require_relative 'piece.rb'
require_relative 'sliding.rb'

class Rook < Piece
  include 'sliding'

  def move_dir
    sideways
  end

  def render
    color == :white ? '♖' : "♜"
  end

end
