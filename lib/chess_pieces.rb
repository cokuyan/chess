class Piece
  attr_writer :pos
  attr_reader :pos, :color

  def initialize(pos, board, color)
    @pos, @board, @color = pos, board, color
  end

  def moves
    # return array of places can move
  end

  def dup(board)
    self.class.new(@pos, board, @color)
  end

  def move_into_check?(pos)
    test_board = @board.dup

    test_board.move!(@pos, pos)
    test_board.in_check?(self.color)
  end

  def valid_moves
    self.moves.reject do |move|
      move_into_check?(move)
    end
  end

  def enemy?(piece)
    self.color != piece.color
  end

end

# bishop, rook, queen
class SlidingPiece < Piece

  def moves
    moves = []

    self.class::DELTAS.each do |(dx,dy)|
      x, y = @pos[0] + dx, @pos[1] + dy
      while x.between?(0,7) && y.between?(0,7) && @board[[x, y]].nil?
        moves << [x, y]
        x += dx
        y += dy
      end
      # check if enemy piece in [x, y], and add it
      moves << [x, y] if @board[[x,y]] && @board[[x,y]].enemy?(self)
    end

    moves
  end

end

class Rook < SlidingPiece

  DELTAS = [
            [1,0],
            [-1,0],
            [0,1],
            [0,-1],
          ]

  def render
    color == :white ? 'r' : "R"
  end

end

class Bishop < SlidingPiece

  DELTAS = [
            [1,-1],
            [-1,1],
            [1,1],
            [-1,-1]
            ]

  def render
    color == :white ? 'b' : "B"
  end

end

class Queen < SlidingPiece

  DELTAS = [
            [1,0],
            [-1,0],
            [0,1],
            [0,-1],
            [1,-1],
            [-1,1],
            [1,1],
            [-1,-1]
            ]

  def render
    color == :white ? 'q' : "Q"
  end

end
#king knight
class SteppingPiece < Piece

  def moves
    moves = []

    x, y = @pos
    self.class::DELTAS.each do |(dx,dy)|
      new_move = [x + dx, y + dy]
      next unless new_move.all? { |el| el.between?(0,7) }
      next if @board[new_move] && @board[new_move].color == self.color
      moves << new_move
    end

    moves
  end



end

class Knight < SteppingPiece

  DELTAS = [
            [2,1],
            [1,2],
            [-2,1],
            [2,-1],
            [-2,-1],
            [-1,2],
            [1,-2],
            [-1,-2]
            ]

  def render
    color == :white ? 'n' : "N"
  end

end

class King < SteppingPiece

  DELTAS = [
            [1,0],
            [-1,0],
            [0,1],
            [0,-1],
            [1,-1],
            [-1,1],
            [1,1],
            [-1,-1]
            ]

  def render
    color == :white ? 'k' : "K"
  end

end

class Pawn < Piece

  DIAGONALS = [
               [1,1],
               [1,-1]
              ]

  FORWARDS = [
              [1,0],
              [2,0]
             ]

  def initialize(pos, board, color)
    super
    @start = @pos
  end

  def moves
    moves = []

    operator = @color == :white ? :- : :+ # metaprogramming!!

    x, y = @pos
    FORWARDS.each do |(dx, dy)|
      move = [x.send(operator, dx), y + dy]
      moves << move unless @board[move]
      break unless @start == @pos # don't count second move if already moved
    end

    DIAGONALS.each do |(dx, dy)|
      move = [x.send(operator, dx), y + dy]
      moves << move unless @board[move].nil?
    end

    moves
  end

  def render
    color == :white ? 'p' : "P"
  end

end
