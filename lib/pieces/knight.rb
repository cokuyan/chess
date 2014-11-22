require_relative 'piece.rb'
require_relative 'stepping.rb'

class Knight < Piece
  include 'stepping'

  DELTAS = [
            [2,1],
            [1,2],
            [-2,1],
            [2,-1],
            [-2,-1],
            [-1,2],
            [1,-2],
            [-1,-2]
            ]

  def move_dir
    DELTAS
  end

  def render
    color == :white ? '♘' : "♞"
  end

end
