require 'rails_helper'

RSpec.describe Site, type: :model do

    before do
    end

    describe 'サイトモデル機能', type: :model do
        describe 'バリデーション' do
            context 'サイト名称が空' do
                it 'バリデーションに引っかかる' do
                end
            end
            context 'サイト住所が空' do
                it 'バリデーションに引っかかる' do
                end
            end
        end
    end
end