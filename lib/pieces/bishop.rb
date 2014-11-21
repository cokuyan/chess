class Bishop < SlidingPiece

  def move_dir
    diagonal
  end

  def render
    color == :white ? '♗' : "♝"
  end

end
