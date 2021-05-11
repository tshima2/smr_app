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
      it 'サイト名称が128文字以上' do
        _name=""; 130.times.each { _name += (('a'..'z').to_a.sample) }; _address="address";
        site = Site.create(name: _name, address: _address, user_id: @user.id, team_id: @team.id)
        expect(site).not_to be_valid
      end
      # 住所が空でもサイトを登録させるよう変更
      xit 'サイト住所が空' do
        _name="name"; _address="";
        site = Site.create(name: _name, address: _address, user_id: @user.id, team_id: @team.id)
        expect(site).not_to be_valid
      end
      it 'サイト住所が255文字以上' do
        _name="name"; _address=""; 256.times.each { _address += (('a'..'z').to_a.sample) }
        site = Site.create(name: _name, address: _address, user_id: @user.id, team_id: @team.id)
        expect(site).not_to be_valid
      end
      it 'メモが255文字以上' do
        _name="name"; _address="address"; _memo=""; 256.times.each { _memo += (('a'..'z').to_a.sample) }
        site = Site.create(name: _name, address: _address, memo: _memo, user_id: @user.id, team_id: @team.id)
        expect(site).not_to be_valid
      end
    end
  end
end
