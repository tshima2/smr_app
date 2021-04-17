require 'rails_helper'


RSpec.describe Site, type: :model do

  before do
    @user=FactoryBot.create(:user)
    @team=FactoryBot.create(:team)
  end

  describe 'サイトモデル機能', type: :model do
    describe 'バリデーション' do
      it 'サイト名称が空' do
        _name=""; _address="address";
        site = Site.create(name: _name, address: _address, user_id: @user.id, team_id: @team.id)
        expect(site).not_to be_valid
      end
      it 'サイト住所が空' do
        _name="name"; _address="";
        site = Site.create(name: _name, address: _address, user_id: @user.id, team_id: @team.id)
        expect(site).not_to be_valid
      end
    end
  end
end
