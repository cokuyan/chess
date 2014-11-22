module Stepping

  def moves
    moves = []

    self.move_dir.each do |dir|
      move = @pos.zip(dir).map { |coor| coor.inject(:+) }
      next unless @board.on_board?(move)
      moves << move if @board[move].nil? || @board[move].is_enemy?(self)
    end

    moves
  end

end
