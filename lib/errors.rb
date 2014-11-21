class ChessError < StandardError
end

class PromotionError < ChessError
end

class PieceSelectionError < ChessError
  def message
    "You chose an empty spot!"
  end
end

class InCheckError < ChessError
  def message
    "You're still in check!"
  end
end

class InvalidMoveError < ChessError
  def message
    "Invalid move!"
  end
end

class InvalidPositionError < ChessError
end
