require 'rails_helper'


RSpec.describe User, type: :model do

  before do
    @user = FactoryBot.create(:user)    
  end

  describe 'ユーザモデル機能', type: :model do
    describe 'バリデーション' do
      it 'Eメールが空' do
        _name=Faker::Name.last_name; _email=""; _password=Faker::Internet.password(min_length: 6)
        user = User.create(name: _name, email: _email, password: _password)
        expect(user).not_to be_valid
      end
      it '名前が空' do
        _name=""; _email=Faker::Internet.free_email; _password=Faker::Internet.password(min_length: 6)
        user = User.create(name: _name, email: _email, password: _password)
        expect(user).not_to be_valid
      end
      it 'パスワードが空' do
        _name=Faker::Name.last_name; _email=Faker::Internet.free_email; _password=""
        user = User.create(name: _name, email: _email, password: _password)
        expect(user).not_to be_valid
      end
    end

    describe '更新' do
      it 'Eメールが空だと更新できない' do
        _email=""
        @user.update(email: _email)
        expect(@user).not_to be_valid
      end
      it '名前が空だと更新できない' do
        _name=""
        @user.update(name: _name)
        expect(@user).not_to be_valid
      end
      it 'パスワードが空だと更新できない' do
        _password=""
        @user.update(password: _password)
        expect(@user).not_to be_valid
      end
    end
  end

end
