class SlidingPiece < Piece

  SIDEWAYS = [
    [1,0],
    [-1,0],
    [0,1],
    [0,-1]
  ]

  DIAGONAL = [
    [1,-1],
    [-1,1],
    [1,1],
    [-1,-1]
  ]

  def sideways
    SIDEWAYS
  end

  def diagonal
    DIAGONAL
  end

  def moves
    moves = []

    self.move_dir.each do |(dx,dy)|
      x, y = @pos[0] + dx, @pos[1] + dy
      while x.between?(0,7) && y.between?(0,7) && @board[[x, y]].nil?
        moves << [x, y]
        x += dx
        y += dy
      end
      # check if enemy piece in [x, y], and add it
      moves << [x, y] if @board[[x,y]] && @board[[x,y]].is_enemy?(self)
    end

    moves
  end

end
