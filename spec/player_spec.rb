require './lib/player.rb'

describe Player do
  subject(:player) { described_class.new('black') }
  context 'when a new player is created' do
    it 'capitalizes the player color and sets as name' do
      #allow(player).receive(:color).and_return('black')
      expect(player.name).to eq("Black")
    end
  end

end