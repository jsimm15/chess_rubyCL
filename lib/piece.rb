require_relative 'player.rb'


class Piece
attr_accessor :color, :type, :position, :available_moves, :marker

  def initialize(color, type, position)
    @color = color
    @type = type
    @position = position
    @available_moves = []
    unicode_values = {
      white_pawn: "\u2659",
      white_knight: "\u2658",
      white_bishop: "\u2657",
      white_rook: "\u2656",
      white_queen: "\u2655",
      white_king: "\u2654",
      black_pawn: "\u265F",
      black_knight: "\u265E",
      black_bishop: "\u265D",
      black_rook: "\u265C",
      black_queen: "\u265B",
      black_king: "\u265A",
    }
    @marker = unicode_values[:"#{color}_#{type}"] + " "
  end

end