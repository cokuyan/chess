class Pawn < Piece

  DIAGONALS = [
               [1,1],
               [1,-1]
              ]

  FORWARDS = [
              [1,0],
              [2,0]
             ]

  def moves
    forward_moves + diag_moves
  end

  def render
    color == :white ? '♙' : "♟"
  end

  def en_passant(start)
    passant_pawn = @board[[start[0], @pos[1]]]
    return if passant_pawn.nil?
    if passant_pawn.is_enemy?(self) && passant_pawn.has_moved == :two_spaces
      @board[[start[0], @pos[1]]] = nil
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

  def forward_moves
    moves = []
    operator = @color == :white ? :- : :+ # metaprogramming!!

    x, y = @pos
    FORWARDS.each do |(dx, dy)|
      move = [x.send(operator, dx), y + dy]
      moves << move unless @board[move] || @board[[x.send(operator, 1), y + dy]]
      break if @has_moved # don't count second move if already moved
    end

    moves
  end

  def diag_moves
    moves = []
    operator = @color == :white ? :- : :+ # metaprogramming!!

    x, y = @pos
    DIAGONALS.each do |(dx, dy)|
      move = [x.send(operator, dx), y + dy]
      passant_pawn = @board[[x, y + dy]]
      moves << move if passant_pawn && passant_pawn.is_enemy?(self) &&
                       passant_pawn.has_moved == :two_spaces
      moves << move if @board[move] && @board[move].is_enemy?(self)
    end

    moves
  end


end
