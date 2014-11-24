class Pawn < Piece

  DIAG = [
          [1,1],
          [1,-1]
         ]

  def moves
    forward_moves + diag_moves
  end

  def render
    color == :white ? '♙' : "♟"
  end

  # Needs to be refactored, especially in Board::move
  def en_passant(start_pos)
    passant_pawn = @board[[start_pos[0], @pos[1]]]
    return if passant_pawn.nil?
    if passant_pawn.is_enemy?(self) && passant_pawn.has_moved == :two_spaces
      @board[[start_pos[0], @pos[1]]] = nil
    end
  end

  def promote
    puts 'What would you like to promote your pawn to?'
    begin
      response = Object.const_get(gets.chomp.capitalize)
      if response == King || response == Pawn
        raise PromotionError.new("Cannot promote to #{response}")
      end
    rescue PromotionError => e
      puts e.message
      retry
    end

    response.new(@pos, @board, @color, true)
  end

  private

  def has_moved?
    @has_moved
  end

  def forward_moves
    moves = []
    move_dir = @color == :white ? [-1, 0] : [1, 0]
    move = add_arrays(@pos, move_dir)
    if @board.on_board?(move) && @board[move].nil?
      moves << move
      move = add_arrays(move, move_dir)
      moves << move unless has_moved? && @board[move]
    end

    moves
  end

  def diag_moves
    moves = []
    move_dir = @color == :white ? DIAG.map { |dx, dy| [-1 * dx, dy] } : DIAG

    move_dir.each do |dir|
      move = add_arrays(@pos, dir)
      next unless @board.on_board?(move)
      passant_pos = [@pos.first, @pos.last + dir.last]
      if (@board[move] && @board[move].is_enemy?(self)) ||
         (@board[passant_pos].is_a?(Pawn) &&
          @board[passant_pos].is_enemy?(self) &&
          @board[passant_pos].has_moved == :two_spaces)
        moves << move
      end
    end

    moves
  end

end
