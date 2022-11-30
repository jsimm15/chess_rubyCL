require_relative 'player.rb'
require_relative 'piece.rb'

require 'colorize'
require 'colorized_string'

class Board
attr_accessor :grid, :active_player, :black_pieces, :white_pieces, :captured_pieces

  def initialize()
    @grid = Array.new(8) { Array.new(8) { "" } }
    self.create_board
    @black_pieces = Hash.new
    @white_pieces = Hash.new
    @captured_pieces = []

    @black_pieces = {
      p1: p1 = Piece.new('black', 'pawn', [1,0]),
      p2: p2 = Piece.new('black', 'pawn', [1,1]),
      p3: p3 = Piece.new('black', 'pawn', [1,2]),
      p4: p4 = Piece.new('black', 'pawn', [1,3]),
      p5: p5 = Piece.new('black', 'pawn', [1,4]),
      p6: p6 = Piece.new('black', 'pawn', [1,5]),
      p7: p7 = Piece.new('black', 'pawn', [1,6]),
      p8: p8 = Piece.new('black', 'pawn', [1,7]),
      r1: r1 = Piece.new('black', 'rook', [0,0]),
      r2: r2 = Piece.new('black', 'rook', [0,7]),
      k1: k1 = Piece.new('black', 'knight', [0,1]),
      k2: k2 = Piece.new('black', 'knight', [0,6]),
      b1: b1 = Piece.new('black', 'bishop', [0,2]),
      b2: b2 = Piece.new('black', 'bishop', [0,5]),
      queen: queen = Piece.new('black', 'queen', [0, 4]),
      king: king = Piece.new('black', 'king', [0,3]),
    }
    @white_pieces = {
      p1: p1 = Piece.new('white', 'pawn', [6,0]),
      p2: p2 = Piece.new('white', 'pawn', [6,1]),
      p3: p3 = Piece.new('white', 'pawn', [6,2]),
      p4: p4 = Piece.new('white', 'pawn', [6,3]),
      p5: p5 = Piece.new('white', 'pawn', [6,4]),
      p6: p6 = Piece.new('white', 'pawn', [6,5]),
      p7: p7 = Piece.new('white', 'pawn', [6,6]),
      p8: p8 = Piece.new('white', 'pawn', [6,7]),
      r1: r1 = Piece.new('white', 'rook', [7,0]),
      r2: r2 = Piece.new('white', 'rook', [7,7]),
      k1: k1 = Piece.new('white', 'knight', [7,1]),
      k2: k2 = Piece.new('white', 'knight', [7,6]),
      b1: b1 = Piece.new('white', 'bishop', [7,2]),
      b2: b2 = Piece.new('white', 'bishop', [7,5]),
      queen: queen = Piece.new('white', 'queen', [7, 3]),
      king: king = Piece.new('white', 'king', [7,4]),
    }

    self.fill_pieces
  end

  def legal_moves(piece)
    color = piece.color
    type = piece.type
    position = piece.position
    one_down = [position[0] + 1, position[1]]
    two_down = [position[0] + 2, position[1]]
    one_up = [position[0] - 1, position[1]]
    two_up = [position[0] - 2, position[1]]
    one_right = [position[0], position[1] + 1]
    one_left = [position[0], position[1] - 1]
    diag_down_right = [position[0] + 1, position[1] + 1]
    diag_down_left = [position[0] + 1, position[1] - 1]
    diag_up_right = [position[0] - 1, position[1] + 1]
    diag_up_left = [position[0] - 1, position[1] - 1]
    knights = []
    knights << knight1 = [position[0] + 2, position[1] + 1]
    knights << knight2 = [position[0] + 1, position[1] + 2]
    knights << knight3 = [position[0] - 1, position[1] + 2]
    knights << knight4 = [position[0] - 2, position[1] + 1]
    knights << knight5 = [position[0] - 2, position[1] - 1]
    knights << knight6 = [position[0] - 1, position[1] - 2]
    knights << knight7 = [position[0] + 1, position[1] - 2]
    knights << knight8 = [position[0] + 2, position[1] - 1]
    
    rook_moves = [one_up, one_down, one_left, one_right]
    bishop_moves = [diag_down_left, diag_down_right, diag_up_left, diag_up_right]
    royal_moves = [one_up, one_down, one_left, one_right,
    diag_down_left, diag_down_right, diag_up_left, diag_up_right]
    

    case color
    when 'black'
      case type
      when 'pawn' 
        #If pawn is in starting row, it can move one or two spaces forward if that square is empty
        if empty?(one_down)
          piece.available_moves << one_down unless !on_board?(one_down)
        end
        if position[0] == 1 && empty?(one_down) && empty?(two_down)
          piece.available_moves << two_down
        end
        #If opponent piece is one space diagonal (capturable), that square is available
        piece.available_moves << diag_down_right if  occupied_by_white?(diag_down_right) unless !on_board?(diag_down_right)
        piece.available_moves << diag_down_left if occupied_by_white?(diag_down_left) unless !on_board?(diag_down_left)
      
      when 'rook'
        # #Rook can move forward until it encounters another piece or reaches the end of the board
        # while empty?(one_down) && on_board?(one_down)
        #   piece.available_moves << one_down
        #   one_down[0] += 1
        # end
        # #Rooks can move in both vertical directions
        # while empty?(one_up) && on_board?(one_up)
        #   piece.available_moves << one_up
        #   one_up[0] -= 1
        # end
        # #Rooks can move left
        # while empty?(one_left) && on_board?(one_left)
        #   piece.available_moves << one_left
        #   one_left[1] -= 1
        # end
        # #Rooks can move right
        # while empty?(one_right) && on_board?(one_right)
        #   piece.available_moves << one_right
        #   one_right[1] += 1
        # end
        # #Rook can move forward if piece occupying next square is opponent piece
        # piece.available_moves << one_up if occupied_by_white?(one_up)
        # piece.available_moves << one_down if occupied_by_white?(one_down)
        # piece.available_moves << one_left if occupied_by_white?(one_left)
        # piece.available_moves << one_right if occupied_by_white?(one_right)
        rook_moves.each do |move|
          while on_board?(move) && (empty?(move) || occupied_by_white?(move))
            piece.available_moves << [move[0], move[1]]
            if occupied_by_white?(move)
              break
            else
              case move
              when one_up
                move[0] -= 1
              when one_down
                move[0] += 1
              when one_left 
                move[1] -= 1
              when one_right
                move[1] += 1
              else
                puts "Something went wrong in legal_moves "
              end
            end
          end
        end
      
      when 'knight'
        knights.each do |knight_move|
          piece.available_moves << knight_move if on_board?(knight_move) && empty?(knight_move)
          piece.available_moves << knight_move if on_board?(knight_move) && occupied_by_white?(knight_move)
        end

      when 'bishop'
        #Bishop can move along any diagonal until it encounters another piece
        # while empty?(diag_up_right) && on_board?(diag_up_right) do
        #   p diag_up_right
        #   piece.available_moves << diag_up_right
        #   diag_up_right[0] -= 1
        #   diag_up_right[1] += 1
        # end
        # while empty?(diag_up_left) && on_board?(diag_up_left) do
        #   piece.available_moves << diag_up_left
        #   diag_up_left[0] -= 1
        #   diag_up_left[1] -= 1
        # end
        # while empty?(diag_down_right) && on_board?(diag_down_right) do
        #   piece.available_moves << diag_down_right
        #   diag_down_right[0] += 1
        #   diag_down_right[1] += 1
        # end
        # while empty?(diag_down_left) && on_board?(diag_down_left) do
        #   piece.available_moves << diag_down_left
        #   diag_down_left[0] += 1
        #   diag_down_left[1] -= 1
        # end
        # #Bishop can continue diagonal move if occupying piece belongs to opponent
        # piece.available_moves << diag_up_left if occupied_by_white?(diag_up_left)
        # piece.available_moves << diag_up_right if occupied_by_white?(diag_up_right)
        # piece.available_moves << diag_down_left if occupied_by_white?(diag_down_left)
        # piece.available_moves << diag_down_right if occupied_by_white?(diag_down_right)
        bishop_moves.each do |move|
        
          while on_board?(move) && (empty?(move) || occupied_by_white?(move))
            piece.available_moves << [move[0], move[1]]
            if occupied_by_white?(move)
              break
            else
              case move
              when diag_up_right
                move[0] -= 1
                move[1] += 1
              when diag_up_left
                move[0] -= 1
                move[1] -=1
              when diag_down_right
                move[0] += 1
                move[1] += 1
              when diag_down_left
                move[0] += 1
                move[1] -= 1
              else
                puts "Something went wrong in legal_moves "
              end
            end
          end
        end



      when 'queen'
        #Queen can move move along any vertical, horizontal, or diagonal until it encounters another piece
        # while empty?(one_up) && on_board?(one_up)
        #   piece.available_moves << one_up
        #   one_up[0] -= 1
        # end
        # while empty?(one_down) && on_board?(one_down)
        #   piece.available_moves << one_down
        #   one_down[0] += 1
        # end
        # while empty?(one_left) && on_board?(one_left)
        #   piece.available_moves << one_left
        #   one_left[1] -= 1
        # end
        # while empty?(one_right) && on_board?(one_right)
        #   piece.available_moves << one_right
        #   one_right[1] += 1
        # end
        # while empty?(diag_up_left) && on_board?(diag_up_left)
        #   piece.available_moves << diag_up_left
        #   diag_up_left[0] -= 1
        #   diag_up_left[1] -= 1
        # end
        # while empty?(diag_up_right) && on_board?(diag_up_right)
        #   piece.available_moves << diag_up_right
        #   diag_up_right[0] -= 1
        #   diag_up_right[1] += 1
        # end
        # while empty?(diag_down_left) && on_board?(diag_down_left)
        #   piece.available_moves << diag_down_left
        #   diag_down_left[0] += 1
        #   diag_down_left[1] -= 1
        # end
        #Trying something different, did not work
        # loop do
        #   if !on_board?(diag_down_left)
        #     break
        #   end
        #   if !empty?(diag_down_left) && occupied_by_black?(diag_down_left)
        #     break
        #   end
        #   if empty?(diag_down_left) || occupied_by_white?(diag_down_left)
        #     piece.available_moves << diag_down_left
        #     diag_down_left[0] -= 1
        #     diag_down_left[0] += 1
        #   end
        # end
        # piece.available_moves << one_up if occupied_by_white?(one_up)
        # piece.available_moves << one_down if occupied_by_white?(one_down)
        # piece.available_moves << one_left if occupied_by_white?(one_left)
        # piece.available_moves << one_right if occupied_by_white?(one_right)
        # piece.available_moves << diag_up_left if occupied_by_white?(diag_up_left)
        # piece.available_moves << diag_up_right if occupied_by_white?(diag_up_right)
        # piece.available_moves << diag_down_left if occupied_by_white?(diag_down_left)
        # piece.available_moves << diag_down_right if occupied_by_white?(diag_down_right)
        royal_moves.each do |move|
        
          while on_board?(move) && (empty?(move) || occupied_by_white?(move))
            piece.available_moves << [move[0], move[1]]
            if occupied_by_white?(move)
              break
            else
              case move
              when diag_up_right
                move[0] -= 1
                move[1] += 1
              when diag_up_left
                move[0] -= 1
                move[1] -=1
              when diag_down_right
                move[0] += 1
                move[1] += 1
              when diag_down_left
                move[0] += 1
                move[1] -= 1
              when one_up
                move[0] -= 1
              when one_down
                move[0] += 1
              when one_left 
                move[1] -= 1
              when one_right
                move[1] += 1
              else
                puts "Something went wrong in legal_moves "
              end
            end
          end
        end



      when 'king'
        #King can move one square in any direction if that square is empty or occupied by an opponent piece
        # piece.available_moves << one_up if occupied_by_white?(one_up) || empty?(one_up)
        # piece.available_moves << one_down if occupied_by_white?(one_down) || empty?(one_down)
        # piece.available_moves << one_left if occupied_by_white?(one_left) || empty?(one_left)
        # piece.available_moves << one_right if occupied_by_white?(one_right) || empty?(one_right)
        # piece.available_moves << diag_up_left if occupied_by_white?(diag_up_left) || empty?(diag_up_left)
        # piece.available_moves << diag_up_right if occupied_by_white?(diag_up_right) || empty?(diag_up_right)
        # piece.available_moves << diag_down_left if occupied_by_white?(diag_down_left) || empty?(diag_down_left)
        # piece.available_moves << diag_down_right if occupied_by_white?(diag_down_right) || empty?(diag_down_right)
        
        royal_moves.each do |move|
          if on_board?(move)
            if occupied_by_white?(move) || empty?(move)
              piece.available_moves << move
            end
          end
        end

      else
        puts "Error. Invalid piece type"
        return nil
      end

    when 'white'
      case type
      when 'pawn' 
        #If pawn is in starting row, it can move one or two spaces forward if that square is empty
        if empty?(one_up)
          piece.available_moves << one_up unless !on_board?(one_up)
        end
        if position[0] == 6 && empty?(one_up) && empty?(two_up)
            piece.available_moves << two_up
        end
        #If opponent piece is one space diagonal (capturable), that square is available
        piece.available_moves << diag_up_right if occupied_by_black?(diag_up_right) unless !on_board?(diag_up_right)
        piece.available_moves << diag_up_left if occupied_by_black?(diag_up_left) unless !on_board?(diag_up_left)

      when 'rook'
        #Rook can move forward until it encounters another piece or reaches the end of the board
        # while empty?(one_down) && on_board?(one_down)
        #   piece.available_moves << one_down
        #   one_down[0] += 1
        # end
        # #Rooks can move in both vertical directions
        # while empty?(one_up) && on_board?(one_up)
        #   piece.available_moves << one_up
        #   one_up[0] -= 1
        # end
        # #Rooks can move left
        # while empty?(one_left) && on_board?(one_left)
        #   piece.available_moves << one_left
        #   one_left[1] -= 1
        # end
        # #Rooks can move right
        # while empty?(one_right) && on_board?(one_right)
        #   piece.available_moves << one_right
        #   one_right[1] += 1
        # end
        # #Rook can move forward if piece occupying next square is opponent piece
        # piece.available_moves << one_up if occupied_by_black?(one_up)
        # piece.available_moves << one_down if occupied_by_black?(one_down)
        # piece.available_moves << one_left if occupied_by_black?(one_left)
        # piece.available_moves << one_right if occupied_by_black?(one_right)
        rook_moves.each do |move|
          while on_board?(move) && (empty?(move) || occupied_by_black?(move))
            piece.available_moves << [move[0], move[1]]
            if occupied_by_black?(move)
              break
            else
              case move
              when one_up
                move[0] -= 1
              when one_down
                move[0] += 1
              when one_left 
                move[1] -= 1
              when one_right
                move[1] += 1
              else
                puts "Something went wrong in legal_moves "
              end
            end
          end
        end

      when 'knight'
        knights.each do |knight_move|
          piece.available_moves << knight_move if on_board?(knight_move) && empty?(knight_move)
          piece.available_moves << knight_move if on_board?(knight_move) && occupied_by_black?(knight_move)
        end

      when 'bishop'
        #Bishop can move along any diagonal until it encounters another piece
        # while on_board?(diag_up_right) && empty?(diag_up_right) do
        #   piece.available_moves << diag_up_right
        #   diag_up_right[0] -= 1
        #   diag_up_right[1] += 1
        # end
        # while empty?(diag_up_left) && on_board?(diag_up_left) do
        #   piece.available_moves << diag_up_left
        #   diag_up_left[0] -= 1
        #   diag_up_left[1] -= 1
        # end
        # while empty?(diag_down_right) && on_board?(diag_down_right) do
        #   piece.available_moves << diag_down_right
        #   diag_down_right[0] += 1
        #   diag_down_right[1] += 1
        # end
        # while empty?(diag_down_left) && on_board?(diag_down_left) do
        #   piece.available_moves << diag_down_left
        #   diag_down_left[0] += 1
        #   diag_down_left[1] -= 1
        # end
        # #Bishop can continue diagonal move if occupying piece belongs to opponent
        # piece.available_moves << diag_up_left if occupied_by_black?(diag_up_left)
        # piece.available_moves << diag_up_right if occupied_by_black?(diag_up_right)
        # piece.available_moves << diag_down_left if occupied_by_black?(diag_down_left)
        # piece.available_moves << diag_down_right if occupied_by_black?(diag_down_right)
        bishop_moves.each do |move|
        
          while on_board?(move) && (empty?(move) || occupied_by_black?(move))
            piece.available_moves << [move[0], move[1]]
            if occupied_by_black?(move)
              break
            else
              case move
              when diag_up_right
                move[0] -= 1
                move[1] += 1
              when diag_up_left
                move[0] -= 1
                move[1] -=1
              when diag_down_right
                move[0] += 1
                move[1] += 1
              when diag_down_left
                move[0] += 1
                move[1] -= 1
              else
                puts "Something went wrong in legal_moves "
              end
            end
          end
        end

      when 'queen'
        #Queen can move move along any vertical, horizontal, or diagonal until it encounters another piece
        # while empty?(one_up) && on_board?(one_up)
        #   piece.available_moves << one_up
        #   one_up[0] -= 1
        # end
        # while empty?(one_down) && on_board?(one_down)
        #   piece.available_moves << one_down
        #   one_down[0] += 1
        # end
        # while empty?(one_left) && on_board?(one_left)
        #   piece.available_moves << one_left
        #   one_left[1] -= 1
        # end
        # while empty?(one_right) && on_board?(one_right)
        #   piece.available_moves << one_right
        #   one_right[1] += 1
        # end
        # while empty?(diag_up_left) && on_board?(diag_up_left)
        #   piece.available_moves << diag_up_left
        #   diag_up_left[0] -= 1
        #   diag_up_left[1] -= 1
        # end
        # while empty?(diag_up_right) && on_board?(diag_up_right)
        #   piece.available_moves << diag_up_right
        #   diag_up_right[0] -= 1
        #   diag_up_right[1] += 1
        # end
        # while empty?(diag_down_left) && on_board?(diag_down_left)
        #   piece.available_moves << diag_down_left
        #   diag_down_left[0] += 1
        #   diag_down_left[1] -= 1
        # end
        # while empty?(diag_down_right) && on_board?(diag_down_right)
        #   piece.available_moves << diag_down_right
        #   diag_down_right[0] += 1
        #   diag_down_right[1] += 1
        # end
        # piece.available_moves << one_up if occupied_by_black?(one_up)
        # piece.available_moves << one_down if occupied_by_black?(one_down)
        # piece.available_moves << one_left if occupied_by_black?(one_left)
        # piece.available_moves << one_right if occupied_by_black?(one_right)
        # piece.available_moves << diag_up_left if occupied_by_black?(diag_up_left)
        # piece.available_moves << diag_up_right if occupied_by_black?(diag_up_right)
        # piece.available_moves << diag_down_left if occupied_by_black?(diag_down_left)
        # piece.available_moves << diag_down_right if occupied_by_black?(diag_down_right)
        royal_moves.each do |move|
        
          while on_board?(move) && (empty?(move) || occupied_by_black?(move))
            piece.available_moves << [move[0], move[1]]
            if occupied_by_black?(move)
              break
            else
              case move
              when diag_up_right
                move[0] -= 1
                move[1] += 1
              when diag_up_left
                move[0] -= 1
                move[1] -=1
              when diag_down_right
                move[0] += 1
                move[1] += 1
              when diag_down_left
                move[0] += 1
                move[1] -= 1
              when one_up
                move[0] -= 1
              when one_down
                move[0] += 1
              when one_left 
                move[1] -= 1
              when one_right
                move[1] += 1
              else
                puts "Something went wrong in legal_moves "
              end
            end
          end
        end

      when 'king'
        #King can move one square in any direction if that square is empty or occupied by an opponent piece
        # piece.available_moves << one_up if occupied_by_black?(one_up) || empty?(one_up)
        # piece.available_moves << one_down if occupied_by_black?(one_down) || empty?(one_down)
        # piece.available_moves << one_left if occupied_by_black?(one_left) || empty?(one_left)
        # piece.available_moves << one_right if occupied_by_black?(one_right) || empty?(one_right)
        # piece.available_moves << diag_up_left if occupied_by_black?(diag_up_left) || empty?(diag_up_left)
        # piece.available_moves << diag_up_right if occupied_by_black?(diag_up_right) || empty?(diag_up_right)
        # piece.available_moves << diag_down_left if occupied_by_black?(diag_down_left) || empty?(diag_down_left)
        # piece.available_moves << diag_down_right if occupied_by_black?(diag_down_right) || empty?(diag_down_right)
        
        royal_moves.each do |move|
          if on_board?(move)
            if occupied_by_black?(move) || empty?(move)
              piece.available_moves << move
            end
          end
        end


      else
        puts "Error. Invalid piece type"
        return nil
      end

    else
      "Invalid piece color"
      return nil
    end
  end

  def update_all_legal_moves
    @black_pieces.each do |k, piece|
      piece.available_moves = []
      next if piece.position.nil?
      legal_moves(piece)
    end
    @white_pieces.each do |k, piece|
      piece.available_moves = []
      next if piece.position.nil?
      legal_moves(piece)
    end
  end


  def create_board
    (0..7).each do |row|
      (0..7).each do |column|
        if row % 2 == 1
          if column % 2 == 1
            grid[row][column] = "  ".colorize(:background => :cyan)
          else
            grid[row][column] = "  ".colorize(:background => :green)
          end
        else
          if column % 2 == 1
            grid[row][column] = "  ".colorize(:background => :green)
          else
            grid[row][column] = "  ".colorize(:background => :cyan)
          end
        end
      end
    end
  end

  def print_board
    grid.each_with_index do |row, index|
      print "#{index}  "
      puts row.join("")
    end
    print "   "
    puts (0..7).to_a.join(" ")
  end

  def fill_pieces
   
    @black_pieces.each do |k,v| 
      next if v.position.nil?
      pp = v.position
      row = pp[0]
      column = pp[1]
      bg_color = find_bg_color([row, column])
      grid[row][column] = v.marker.colorize(:color => :black, :background => bg_color)
      # if row % 2 == 1
      #   if column % 2 == 1
      #     grid[row][column] = v.marker.colorize(:color => :black, :background => :cyan)
      #   else
      #     grid[row][column] = v.marker.colorize(:color => :black, :background => :green)
      #   end
      # else
      #   if column % 2 == 1
      #     grid[row][column] = v.marker.colorize(:color => :black, :background => :green)
      #   else
      #     grid[row][column] = v.marker.colorize(:color => :black, :background => :cyan)
      #   end
      # end
    end
    @white_pieces.each do |k,v|
      next if v.position.nil?  
      pp = v.position
      row = pp[0]
      column = pp[1]
      bg_color = find_bg_color([row, column])
      grid[row][column] = v.marker.colorize(:background => bg_color)
      # if row % 2 == 1
      #   if column % 2 == 1
      #     grid[row][column] = v.marker.colorize(:background => :cyan)
      #   else
      #     grid[row][column] = v.marker.colorize(:background => :green)
      #   end
      # else
      #   if column % 2 == 1
      #     grid[row][column] = v.marker.colorize(:background => :green)
      #   else
      #     grid[row][column] = v.marker.colorize(:background => :cyan)
      #   end
      # end
    end
  end

  def move_piece(position)
    piece = nil
    target = nil
    until !piece.nil? do
      piece = select_piece(position)
    end
    highlight_square(position)

    until !target.nil? do 
      target = select_target(position, player, piece)
    end
    # if occupied?
    #   capture()
    # end
    # grid[position[0]][position[1]] = piece.marker 
  end

  def select_piece(position, active_player)
    row = position[0]
    column = position[1]
    icon = grid[row][column]
    #p icon
    #return nil if selecting empty square
    return nil if icon == "\e[0;39;46m  \e[0m"
    #return nil if selected other players piece
    return nil if active_player.color == "black" && white_pieces.any? { |key, piece| piece.position == [row, column] }
    return nil if active_player.color == "white" && black_pieces.any? { |key, piece| piece.position == [row, column] }
    #return dict value for selected piece
    active_player.color == 'black' ? pieces = @black_pieces : pieces = @white_pieces
    result = pieces.select { |k,v| v.position == [row, column] }
    #p result
    #p result.values
    return result.values[0]
  end

  def highlight_square(position)
    row = position[0]
    column = position[1]
    grid[row][column] = grid[row][column].colorize(:background => :red)
  end

  def highlight_available_squares(piece)
    squares = piece.available_moves
    squares.each do |square|
      highlight_square(square)
    end
  end
  
  def select_target(position, active_player, piece)
    row = position[0]
    column = position[1]
    icon = grid[row][column]
    active_player.color == "white" ? other_pieces = @black_pieces : other_pieces = white_pieces
    #return nil if selecting square containing piece of same color as user
    return nil if active_player.color == 'black' && @black_pieces.any? { |k, piece| piece.position == [row, column] }
    return nil if active_player.color == 'white' && @white_pieces.any? { |k, piece| piece.position == [row, column] }
    #If target square is not a valid move, return nil. If it is valid, return [row,column] position of target
    #p "a"
    if piece.available_moves.include?(position) #Valid move
    #p "b"
      if other_pieces.any? { |k, piece| piece.position == [row, column] } #Space is occupied by opponent piece
        return [row, column, true]
      else
        return [row, column, false]
      end
    else  #Invalid move. I.e. target not in list of piece.available_moves
      puts "Invalid selection. Try again"
      return nil
    end
  end

  def find_bg_color(position)
    position = position.to_a
    row = position[0]
    column = position[1]

    if row % 2 == 1
      if column % 2 == 1
        return :cyan
      else
        return :green
      end
    else
      if column % 2 == 1
        return :green
      else
        return :cyan
      end
    end
  end
  
  #Helper method to quickly check if a square is empty
  def empty?(square)
    row = square[0]
    col = square[1]
    if @black_pieces.any? { |k,v| v.position == [row, col] } || @white_pieces.any? { |k,v| v.position == [row, col]}
      return false
    else
      return true
    end
  end

  #Helper method to quickly check if position is still on chessboard
  def on_board?(position)
    position[0].between?(0,7) && position[1].between?(0,7)
  end

  #Helper method to quickly check if square is occupied by a white piece
  def occupied_by_white?(square)
    row = square[0]
    col = square[1]
    @white_pieces.any? { |k,v| v.position == [row, col] }
  end

  #Helper method to quickly check if square is occupied by a black piece
  def occupied_by_black?(square)
    row = square[0]
    col = square[1]
    @black_pieces.any? { |k,v| v.position == [row, col] }
  end

  #Debugging method
  def print_all_available_moves
    puts "White Moves"
    @white_pieces.each do |name, piece|
      puts "#{name}: #{piece.available_moves}"
    end
    puts "Black Moves"
    @black_pieces.each do |name, piece|
      puts "#{name}: #{piece.available_moves}"
    end
  end

  def print_captured_pieces
    unless @captured_pieces.nil?
      #p @captured_pieces
      @captured_pieces.each do |piece|
        #p piece
        #next if piece.nil?
        print "#{piece.values[0].marker}"
        print " | "
      end
      puts ''
    end
  end

end
