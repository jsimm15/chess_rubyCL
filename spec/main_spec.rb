require './lib/main.rb'

describe GameRound do

  describe 'switch_active_player' do
    subject(:round) { described_class.new }
    context 'When player1 is the active player' do
      it 'changes the active player to player2' do
        expect { round.switch_active_player }.to change{ round.active_player }.from(round.player1).to(round.player2)
      end
    end

    context 'When player2 is the active player' do
      it 'changes the active player to player2' do
        round.active_player = round.player2
        expect { round.switch_active_player }.to change { round.active_player }.from(round.player2).to(round.player1)
      end
    end
  end


end