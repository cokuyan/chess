require 'colorize'
require_relative 'piece.rb'
require_relative 'stepping.rb'

class King < Piece
  include Stepping

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

  def initialize(pos, board, color, has_moved = false)
    super(pos, board, color)
    @has_moved = has_moved
  end

  def symbol
    symbol = color == :white ? '♔' : '♚'
    @board.in_check?(color)? symbol.on_red : symbol
  end

  def has_moved?
    @has_moved
  end

  def move_dir
    DELTAS
  end

  def move(end_pos)
    @has_moved = true
    super
  end

  def valid_moves
    moves = super
    moves + castle_moves
  end

  def castle
    if pos[1] == 2
      rook_pos = [@pos.first, 0]
      end_pos = add_arrays(rook_pos, [0, 3])
      @board[rook_pos].move(end_pos)
    else
      rook_pos = [@pos.first, 7]
      end_pos = add_arrays(rook_pos, [0, -2])
      @board[rook_pos].move(end_pos)
    end
  end


  private

  def castle_moves
    moves = []
    return moves unless can_castle?
    moves << add_arrays(@pos, [0, 2]) if can_castle_right?
    moves << add_arrays(@pos, [0, -2]) if can_castle_left?
    moves
  end

  def can_castle?
    !has_moved? && !@board.in_check?(color) &&
    (can_castle_right? || can_castle_left?)
  end

  def can_castle_right?
    rook = @board[[@pos.first, 7]]
    [1, 2].map { |el| add_arrays(@pos, [0, el]) }
          .none? { |pos| !@board[pos].nil? || move_into_check?(pos) } &&
    rook && rook.is_a?(Rook) && !rook.has_moved?
  end

  def can_castle_left?
    rook = @board[[@pos.first, 0]]
    [1, 2].map { |el| add_arrays(@pos, [0, -el]) }
          .none? { |pos| !@board[pos].nil? || move_into_check?(pos) } &&
    @board[[@pos[0], 1]].nil? &&
    rook && rook.is_a?(Rook) && !rook.has_moved?
  end

end
