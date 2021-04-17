require 'rails_helper'


RSpec.describe Team, type: :model do

  before do
    @user = FactoryBot.create(:user)
    @team = FactoryBot.create(:team)
  end

  describe 'ユーザモデル機能', type: :model do
    describe 'バリデーション' do
      it '名前が空' do
        _name=""; _owner_id = User.ids.sample
        team = Team.create(name: _name, owner_id: _owner_id)
        expect(team).not_to be_valid
      end
    end

    describe '更新' do
      it '名前が空だと更新できない' do
        _name=""
        @team.update(name: _name)
        expect(@team).not_to be_valid
      end
    end
  end

end
