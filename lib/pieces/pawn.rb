class Pawn < Piece

  DIAG = [
          [1,1],
          [1,-1]
         ]

  def initialize(pos, board, color, has_moved = false)
    super(pos, board, color)
    @has_moved = has_moved
    @moved_two = false
  end

  def moves
    forward_moves + diag_moves
  end

  def render
    color == :white ? '♙' : "♟"
  end

  def move(end_pos)
    @has_moved = true
    # check move two positions
    @moved_two = ((pos[0] - end_pos[0]).abs == 2)
    # also check if en passant
    # put checks into own method?
    if @board[end_pos].nil? && diag_moves.include?(end_pos)
      en_passant(end_pos)
    end

    super
  end

  def en_passant(end_pos)
    passant_pos = [pos[0], end_pos[1]]
    @board[passant_pos] = nil
  end

  def promote
    puts 'What would you like to promote your pawn to?'
    begin
      response = Object.const_get(gets.chomp.capitalize)
      if [King, Pawn].include?(response)
        raise PromotionError.new("Cannot promote to #{response}")
      end
    rescue PromotionError => e
      puts e.message
      retry
    end
    @board[@pos] = nil
    response.new(@pos, @board, @color, true)
  end

  def has_moved?
    @has_moved
  end

  def moved_two?
    @moved_two
  end

  def forward_moves
    moves = []
    move_dir = @color == :white ? [-1, 0] : [1, 0]
    move = add_arrays(@pos, move_dir)
    if @board.on_board?(move) && @board[move].nil?
      moves << move
      return moves if has_moved?
      move = add_arrays(move, move_dir)
      moves << move unless @board[move]
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
          @board[passant_pos].moved_two?)
        moves << move
      end
    end

    moves
  end

end
