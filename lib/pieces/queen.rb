class Queen < SlidingPiece

  def move_dir
    sideways + diagonal
  end

  def render
    color == :white ? '♕' : "♛"
  end

end
