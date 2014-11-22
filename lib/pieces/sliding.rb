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
      move = @pos.zip(dir).map { |coor| coor.inject(:+) }
      # x, y = @pos[0] + dx, @pos[1] + dy
      while @board.on_board?(move) && @board[move].nil?
        moves << move
        move = move.zip(dir).map { |coor| coor.inject(:+) }
      end
      # check if enemy piece in [x, y], and add it
      moves << move if @board[move] && @board[move].is_enemy?(self)
    end

    moves
  end

end
