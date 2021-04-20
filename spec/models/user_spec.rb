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
      it 'Eメールが130文字より長い' do
        _name=Faker::Name.last_name; _email=""; 130.times.each { _email += (('a'..'z').to_a.sample) }; _email += "@example.com" ; _password=Faker::Internet.password(min_length: 6)
        user = User.create(name: _name, email: _email, password: _password)
        expect(user).not_to be_valid
      end
      it 'Eメールが異常形式' do
        _name=Faker::Name.last_name; _email="abc.#def@123"; _password=Faker::Internet.password(min_length: 6)
        user = User.create(name: _name, email: _email, password: _password)
        expect(user).not_to be_valid
      end
      it '名前が空' do
        _name=""; _email=Faker::Internet.free_email; _password=Faker::Internet.password(min_length: 6)
        user = User.create(name: _name, email: _email, password: _password)
        expect(user).not_to be_valid
      end
      it '名前が128文字より長い' do
        _name=""; 130.times.each { _name += (('a'..'z').to_a.sample) }; _email=Faker::Internet.free_email; _password=Faker::Internet.password(min_length: 6)
        user = User.create(name: _name, email: _email, password: _password)
        expect(user).not_to be_valid
      end
      it 'パスワードが空' do
        _name=Faker::Name.last_name; _email=Faker::Internet.free_email; _password=""
        user = User.create(name: _name, email: _email, password: _password)
        expect(user).not_to be_valid
      end
      it 'パスワードが6文字以内' do
        _name=Faker::Name.last_name; _email=Faker::Internet.free_email; _password="shima"
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
      it 'Eメールが128文字より長いと更新できない' do
        _email=""; 130.times.each { _email += (('a'..'z').to_a.sample) }; _email += "@example.com"
        @user.update(email: _email)
        expect(@user).not_to be_valid
      end
      it 'Eメールが異常形式だと更新できない' do
        _email="abc.#def@123";
        @user.update(email: _email)
        expect(@user).not_to be_valid
      end
      it '名前が空だと更新できない' do
        _name=""
        @user.update(name: _name)
        expect(@user).not_to be_valid
      end
      it '名前が128文字より長いと更新できない' do
        _name=""; 130.times.each { _name += (('a'..'z').to_a.sample) }
        @user.update(name: _name)
        expect(@user).not_to be_valid
      end
      it 'パスワードが空だと更新できない' do
        _password=""
        @user.update(password: _password)
        expect(@user).not_to be_valid
      end
      it 'パスワードが6文字以内だと更新できない' do
        _password="shima"
        @user.update(password: _password)
        expect(@user).not_to be_valid
      end
    end
  end

end
