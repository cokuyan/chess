module Sliding

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

    self.move_dir.each do |dir|
      move = add_arrays(@pos, dir)
      # x, y = @pos[0] + dx, @pos[1] + dy
      while @board.on_board?(move) && @board[move].nil?
        moves << move
        move = add_arrays(move, dir)
      end
      # check if enemy piece in [x, y], and add it
      moves << move if @board.on_board?(move) && @board[move] && @board[move].is_enemy?(self)
    end

    moves
  end

end
