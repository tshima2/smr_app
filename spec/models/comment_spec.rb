require 'rails_helper'


RSpec.describe Comment, type: :model do

  before do
    @user = FactoryBot.create(:user)
    @team = FactoryBot.create(:team)
    @site = FactoryBot.create(:site)
    @comment = FactoryBot.create(:comment)
  end

  describe 'コメントモデル機能', type: :model do
    describe 'バリデーション' do
      it 'コンテンツが空だと作成できない' do
        _content=""
        comment = Comment.create(content: _content, user_id: @user.id, site_id: @site.id)
        expect(comment).not_to be_valid
      end
      it 'コンテンツが4096文字より長いと作成できない' do
        _content=""; 5000.times.each { _content += (('a'..'z').to_a.sample) }
        comment = Comment.create(content: _content, user_id: @user.id, site_id: @site.id)
        expect(comment).not_to be_valid
      end
      it 'コンテンツが空だと更新できない' do
        _content=""
        @comment.update(content: _content)
        expect(@comment).not_to be_valid
      end
      it 'コンテンツが4096文字より長いと更新できない' do
        _content=""; 5000.times.each { _content += (('a'..'z').to_a.sample) }
        @comment.update(content: _content)
        expect(@comment).not_to be_valid
      end
    end
  end
end
