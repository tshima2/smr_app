require 'rails_helper'

RSpec.describe 'チーム機能のテスト', type: :system do

  before do
    @default_owner=FactoryBot.create(:default_owner)    #DefaultTeam Owner User
    @default_team=FactoryBot.create(:default_team)      #DefaultTeam, All First User is assigned this team.
    @default_owner.keep_team_id=@default_team.id
    @default_owner.save
    @asgn = @default_team.assigns.build(user_id: @default_owner.id)
    @asgn.save
    @second_team=FactoryBot.create(:team)
    @asgn2 = @second_team.assigns.build(user_id: @default_owner.id)
    @asgn2.save

    @site01 = FactoryBot.create(:site, team_id: @default_team.id)
    @site02 = FactoryBot.create(:site, team_id: @default_team.id)
    @site03 = FactoryBot.create(:site, team_id: @default_team.id)
    @site04 = FactoryBot.create(:site, team_id: @default_team.id)
    @site11 = FactoryBot.create(:site, team_id: @second_team.id)
    @site12 = FactoryBot.create(:site, team_id: @second_team.id)
    @site13 = FactoryBot.create(:site, team_id: @second_team.id)
    @site14 = FactoryBot.create(:site, team_id: @second_team.id)
    @site15 = FactoryBot.create(:site, team_id: @second_team.id)
    @site16 = FactoryBot.create(:site, team_id: @second_team.id)
end


  describe 'チーム作成機能のテスト' do
    before do
    end

    it 'メニューのあたらしくチームを作るメニュークリックでチーム作成ページに遷移すること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.5)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
      
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: 'default_owner@example.com'
      fill_in "user_password", with: 'passwd'
      click_on "user_login_submit"
      sleep(0.5)
      
      #トップページに遷移し, "ログインしました。"が表示されていることを確認
      expect(page).to have_content 'ログインしました。'

      #"マイチーム"ドロップダウンメニューをクリック
      #click_link I18n.t('views.labels.link_menu_my_team')
      find('#link_myteam_dropdown').click
      sleep(0.5)

      #"あたらしくチームを作る"メニューをクリック
      click_link I18n.t('views.labels.link_menu_new_team')
      sleep(0.5)

      #新しいチーム画面に遷移していることを確認
      expect(page).to have_content I18n.t('views.messages.team_build')
    end

    it 'チーム作成画面でチーム作成ができること' do
    end
    
  end

  describe 'チーム選択機能のテスト' do
    before do
    end
    
    it 'メニューのチーム選択メニュークリックでチーム詳細画面に遷移すること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.5)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
      
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: 'default_owner@example.com'
      fill_in "user_password", with: 'passwd'
      click_on "user_login_submit"
      sleep(0.5)
      
      #トップページに遷移し, "ログインしました。"が表示されていることを確認
      expect(page).to have_content 'ログインしました。'

      #"マイチーム"ドロップダウンメニューをクリック
      find('#link_myteam_dropdown').click
      sleep(0.5)

      #"DefaultTeam"をクリック
      click_link @default_team.name
      sleep(0.5)

      #チーム詳細画面に遷移していることを確認
      expect(page).to have_content @default_team.name
      expect(page).to have_content "チームリーダー"
      expect(page).to have_content "#{@default_team.owner.name} <#{@default_team.owner.email}>"
      expect(page).to have_content "チームメンバー"
      @default_team.members.each { |member| "#{member.name} <#{member.email}>" }
      expect(page).to have_content "チームメンバー招待"
    end

    it '選択したチームに応じてメニューの選択アイコンが切り替わっていること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.5)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
      
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: 'default_owner@example.com'
      fill_in "user_password", with: 'passwd'
      click_on "user_login_submit"
      sleep(0.5)
      
      #トップページに遷移し, "ログインしました。"が表示されていることを確認
      expect(page).to have_content 'ログインしました。'

      #"マイチーム"ドロップダウンメニューをクリック
      find('#link_myteam_dropdown').click
      sleep(0.5)

      #"DefaultTeam"をクリック
      click_link @default_team.name
      sleep(0.5)

      #再度"マイチーム"ドロップダウンメニューをクリック
      find('#link_myteam_dropdown').click
      sleep(0.5)
      
      #さっき選択した"DefaultTeam"の前のアイコンがチェック済（fa-check-square）になっていること
      elems = all('.dropdown-item span i')
      expect(elems[0][:class]).to have_content 'fas fa-check-square'
      expect(elems[1][:class]).to have_content 'far fa-square'

    end

    it '選択したチームに応じたサイト一覧が表示されていること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.5)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
      
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: 'default_owner@example.com'
      fill_in "user_password", with: 'passwd'
      click_on "user_login_submit"
      sleep(0.5)
      
      #トップページに遷移し, "ログインしました。"が表示されていることを確認
      expect(page).to have_content 'ログインしました。'

      #"マイチーム"ドロップダウンメニューをクリック
      find('#link_myteam_dropdown').click
      sleep(0.5)

      #"DefaultTeam"をクリック
      click_link @default_team.name
      sleep(0.5)

      #サイト一覧に遷移
      visit team_sites_path(@default_team.id)
      sleep(0.5)

      #サイト一覧画面に遷移し、該当チームのサイト4件が表示されていることを確認
      expect(page).to have_content I18n.t('views.labels.site_index')
      expect(page).to have_content @site01.id
      expect(page).to have_content @site01.name
      expect(page).to have_content @site01.address
      expect(page).to have_content @site01.memo
      expect(page).to have_content @site02.id
      expect(page).to have_content @site02.name
      expect(page).to have_content @site02.address
      expect(page).to have_content @site02.memo
      expect(page).to have_content @site03.id
      expect(page).to have_content @site03.name
      expect(page).to have_content @site03.address
      expect(page).to have_content @site03.memo
      expect(page).to have_content @site04.id
      expect(page).to have_content @site04.name
      expect(page).to have_content @site04.address
      expect(page).to have_content @site04.memo
    end
  end

  describe 'マイチーム機能のテスト' do
    before do
    end
    it 'マイチーム画面にてメンバー招待できること' do
    end 
    it 'メンバー招待すると招待されたメンバーに確認メールが飛ぶこと' do
    end 
    it 'マイチーム画面にてメンバー削除できること' do
    end 
    it 'メンバー削除すると招待されたメンバーに確認メールが飛ぶこと' do
    end 
  end

end 