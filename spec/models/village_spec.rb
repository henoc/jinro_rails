require 'rails_helper'

RSpec.describe Village, type: :model do
  let(:village) { create(:village) }
  it 'has a valid factory' do
    expect(village).to be_valid
  end

  context 'when player_num is 5(minimum)' do
    it 'assign role to players' do
      village = create(:village_with_player, player_num: 5)

      village.assign_role
      roles = Settings.role_list[5]
      expect(village.players.map(&:role)).to match_array roles
    end
  end

  context 'when player_num is 16(maximum)' do
    it 'assign role to players' do
      village = create(:village_with_player, player_num: 16)

      village.assign_role
      roles = Settings.role_list[16]
      expect(village.players.map(&:role)).to match_array roles
    end
  end
end
