class SteppingPiece < Piece

  def moves
    moves = []

    x, y = @pos
    self.class::DELTAS.each do |(dx,dy)|
      move = [x + dx, y + dy]
      next unless move.all? { |el| el.between?(0,7) }
      moves << move if @board[move].nil? || @board[move].is_enemy?(self)
    end

    moves
  end

end
