class Rook < SlidingPiece

  def move_dir
    sideways
  end

  def render
    color == :white ? '♖' : "♜"
  end

end
