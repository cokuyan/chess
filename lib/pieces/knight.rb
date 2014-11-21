class Knight < SteppingPiece

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

  def render
    color == :white ? '♘' : "♞"
  end

end
