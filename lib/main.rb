require_relative 'player.rb'
require_relative 'piece.rb'
require_relative 'board.rb'

# board = Board.new
# #board.fill_pieces('black')
# board.print_board

class GameRound
attr_accessor :board, :player1, :player2, :active_player

  def initialize
    @board = Board.new
    @player1 = Player.new('white')
    @player2 = Player.new('black')
    @active_player = player1

    board.update_all_legal_moves
    board.print_board
  end

  def game_loop
    while !checkmate?
      #board.print_all_available_moves
      piece = nil
      while piece.nil?
        input = prompt_input(active_player)
        piece = board.select_piece(input, active_player)
      end
      #####
      #p piece
      board.highlight_available_squares(piece)
      board.print_board
      target = nil
      while target.nil?
        input = prompt_input(active_player)
        target =board.select_target(input, active_player, piece)
        #select_target returns true if the move results in a capture
      end
      if target[2] == true
        #Allow access to white_pieces or black_pieces depending on active player
        active_player == player1 ? opponent = board.black_pieces : opponent = board.white_pieces
        #Select the opponent piece located at the target position and add to board.captured_pieces
        captured = opponent.select { |k,v| v.position == [target[0], target[1]] }
        captured.values[0].position = nil #Ensure that the removed piece does not reappear at the previous location
        board.captured_pieces << captured
      end
      #Move the selected piece to the target square
      #This action is the same if the target square is occupied or empty, so it can be handled outside
      #the if statement above
      row = target[0]
      column = target[1]
      
      piece.position = [row, column]
      board.create_board
      #After the player move is completed, update the board, print the board, and switch active player
      board.fill_pieces
      board.print_board
      board.print_captured_pieces
      board.update_all_legal_moves
      switch_active_player
    end
  end

  def prompt_input(player)
    puts "#{player.name} please select a square:"
    input = nil
    while (input =~ /[0-7][0-7]/).nil?
      input = gets.chomp   
    end
    position_array = input.split('').map { |num| num = num.to_i }
    # position_array.map! do { |num| num = num.to_i }
    p position_array
    return position_array
  end

  def switch_active_player
    @active_player == player1 ? @active_player = player2 : @active_player = player1
  end

  def checkmate?
    false
  end

end


#Initialize game
game = GameRound.new
game.game_loop