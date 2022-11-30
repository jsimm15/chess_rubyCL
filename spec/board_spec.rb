require './lib/board.rb'

describe Board do

  describe 'select_piece' do 
    subject(:board) { described_class.new }
    let(:player) { instance_double('player', :color => 'black') }
    
    context 'when the user selects an empty square' do
      it 'returns nil' do
        expect(board.select_piece([3,3], player)).to be_nil
      end
    end

    context 'when the user selects a square occupied by the other player' do
      it 'returns nil' do
        expect(board.select_piece([6,2], player)).to be_nil
      end
    end

    context 'when the user selects a valid piece' do
      it 'returns a Piece object' do
        expect(board.select_piece([0,1], player)).to be_an_instance_of(Piece)
      end
    end
  end

  describe 'highlight_square' do
    subject(:board) { described_class.new }
    let(:player) { instance_double('player', :color => 'black') }

    context 'when the user selects a valid square' do
      it 'changes the square color to red' do
        expect { board.highlight_square([1,1]) }.to change { board.grid[1][1] }.from(board.grid[1][1]).to(board.grid[1][1].on_red)
        board.highlight_square([1,1])
      end
    end
  end

  describe 'select_target' do
    subject(:board) { described_class.new }
    let(:player) { instance_double('player', :color => 'black') }
    let(:piece) { instance_double('piece', :color => 'black', :type => 'pawn', :position => [4,1]) }
    context 'when the user tries to select a square occupied by their own piece' do
      it 'returns nil' do
        expect(board.select_target([1,1], player, piece)).to be_nil
      end
    end
    context 'when users selects a valid target that is empty' do
      it 'returns [row, column, false]' do
        allow(piece).to receive(:available_moves).and_return([[3,3]])
        expect(board.select_target([3,3], player, piece)).to eq([3, 3, false])
      end
    end
    context 'when the user selects a valid target that is occupied by an opponent piece' do
      it 'returns [row, column, true]' do
        allow(piece).to receive(:available_moves).and_return([[6,6]])
        expect(board.select_target([6,6], player, piece)).to eq([6, 6, true])
      end
    end
    context 'when the user selects an invalid target(not an available move for selected piece' do
      it 'returns nil' do
        allow(piece).to receive(:available_moves).and_return([[3,3]])
        expect(board.select_target([4,4], player, piece)).to be_nil
      end
    end
  end 

  describe 'empty?' do
    subject(:board) { described_class.new }
    context 'when testing an empty square for empty' do
      it 'returns true' do
        expect(board.empty?([3,3])).to eq(true)
      end
    end

    context 'when testing an occupied square for empty' do
      it 'returns false' do
        expect(board.empty?([1,1])).to eq(false)
      end
    end
  end

  describe 'on_board?' do
    subject(:board) { described_class.new }
    context 'when testing a square that is on the chessboard' do
      it 'returns true' do
        expect(board.on_board?([0,7])).to eq(true)
      end
    end
    
    context 'when testing a square that is outside the chessboard' do
      it 'returns false' do
        expect(board.on_board?([0,-1])).to eq(false)
      end
    end
  end

  describe 'occupied_by_white?' do
    subject(:board) { described_class.new }
    context 'when testing a square occupied by a white piece' do
      it 'returns true' do
        expect(board.occupied_by_white?([6,4])).to eq(true)
      end
    end

    context 'when testing an empty square' do
      it 'returns false' do
        expect(board.occupied_by_white?([3,3])).to eq(false)
      end
    end

    context 'when testing a square occupied by a black piece' do
      it 'returns false' do
        expect(board.occupied_by_white?([1,1])).to eq(false)
      end
    end
  end

  describe 'occupied_by_black?' do 
    subject(:board) { described_class.new }
    context 'when testing a square occupied by a black piece' do
      it 'returns true' do
        expect(board.occupied_by_black?([1,1])).to eq(true)
      end
    end

    context 'when testing an empty square' do
      it 'returns false' do
        expect(board.occupied_by_black?([3,3])).to eq(false)
      end
    end

    context 'when testing a square occupied by a white piece' do
      it 'returns false' do
        expect(board.occupied_by_black?([7,1])).to eq(false)
      end
    end
  end
 
end