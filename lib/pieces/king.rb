require_relative 'piece.rb'
require_relative 'stepping.rb'

class King < Piece
  include 'stepping'

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

  def move_dir
    DELTAS
  end

  # change so that this is called only if a castling move is given
  def castle(start, end_pos)
    difference = start[1] - end_pos[1]
    return if difference.abs == 1

    if difference > 0
      rook_pos = [@pos.first, 0]
      @board.move!(rook_pos, [rook_pos[0], rook_pos[1] + 3])
    else
      rook_pos = [@pos.first, 7]

      @board.move!(rook_pos, [rook_pos[0], rook_pos[1] - 2])
    end
  end

  def valid_moves
    moves = super
    return moves if has_moved?

    right_castle = [@pos.first, @pos.last + 2]
    left_castle = [@pos.first, @pos.last - 2]

    moves << right_castle if can_castle?(get_rooks[1])
    moves << left_castle if can_castle?(get_rooks[0])
    moves
  end

  def get_rooks
    rooks = @board.all_pieces(@color).select do |piece|
      piece.is_a?(Rook) && !piece.has_moved
    end

    right_rook = rooks.select { |rook| rook.pos[1] == 7 }.first
    left_rook = rooks.select { |rook| rook.pos[1] == 0 }.first

    [left_rook, right_rook]
  end

  def can_castle?(rook)
    return false if move_into_check?(@pos)
    return false if rook.nil?


    if self.pos[1] < rook.pos[1]
      (self.pos[1] + 1...rook.pos[1]).each do |col|
        space_pos = [self.pos[0], col]
        return false if @board[space_pos] || move_into_check?(space_pos)
      end

    else
      (rook.pos[1] + 1...self.pos[1]).each do |col|
        space_pos = [self.pos[0], col]
        return false if @board[space_pos] ||
                        (col > 1 && move_into_check?(space_pos))
      end
    end

    true
  end


  def render
    color == :white ? '♔' : '♚'
  end

end
