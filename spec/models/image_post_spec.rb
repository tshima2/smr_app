require 'rails_helper'

RSpec.describe ImagePost, type: :model do

  before do
    @user = FactoryBot.create(:user)
    @team = FactoryBot.create(:team)
    @site = FactoryBot.create(:site)
    @image_post = FactoryBot.create(:image_post)
  end

  describe 'ImagePostモデル機能', type: :model do
    describe 'バリデーション' do
      it '画像が空' do
        _image=nil
        image_post = ImagePost.create(image: _image, user_id: @user.id, site_id: @site.id)
        expect(image_post).not_to be_valid
      end
    end

    describe '更新' do
      it '画像が空だと更新できない' do
        _image=nil
        @image_post.update(image: _image)
        expect(@image_post).not_to be_valid
      end
    end
  end
end