require 'rails_helper'


RSpec.describe Label, type: :model do

  before do
    @user = FactoryBot.create(:user)
    @team = FactoryBot.create(:team)
    @team2 = FactoryBot.create(:team)
    FactoryBot.create(:label, team_id: @team.id)
    FactoryBot.create(:label, team_id: @team.id)
    FactoryBot.create(:label, team_id: @team.id)
    FactoryBot.create(:label, team_id: @team2.id)
    FactoryBot.create(:label, team_id: @team2.id)
  end

  describe 'ラベルモデル機能', type: :model do
    describe 'バリデーション' do
      it 'タイトルが空' do
        _title=""
        label=Label.create(title: _title)
        expect(label).not_to be_valid
      end
    end

    describe 'スコープのテスト' do
      it 'チームidで絞り込める' do
        labels = Label.filter_team(@team.id)
        expect(labels.count).to eq 3
        labels.each do |label|
          expect(label.team_id).to eq @team.id
        end
      end
    end
  end
end
