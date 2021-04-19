require 'rails_helper'

RSpec.describe 'ユーザ登録/ログイン機能のテスト', type: :system do

  before do
    @default_owner=FactoryBot.create(:default_owner)    #DefaultTeam Owner User
    @default_team=FactoryBot.create(:default_team)      #DefaultTeam, All First User is assigned this team.
    @default_owner.keep_team_id=@default_team.id
    @site01 = FactoryBot.create(:site)
    @site02 = FactoryBot.create(:site)
  end

  describe 'ユーザ登録のテスト' do
    before do
    end

    it 'ログインしていない状態で, Signup画面から新規ユーザ登録ができること' do

      #Sign Up 画面に遷移
      visit new_user_registration_path
      sleep(0.5)
      expect(page).to have_content I18n.t('devise.registrations.new.sign_up')

      #名前, メール, パスワード, 確認用パスワードを打ち込み, "アカウント登録"ボタン押下
      fill_in "user_name", with: 'test99'
      fill_in "user_email", with: 'test99@example.com'
      fill_in "user_password", with: 'test99'
      fill_in "user_password_confirmation", with: 'test99'
      click_on "new_user_submit"
      sleep(0.5)

      #トップページに遷移し, "アカウント登録が完了しました。"が表示されていることを確認
      expect(page).to have_content 'アカウント登録が完了しました。'
    end
    
  end

  describe 'ログイン機能のテスト' do
    before do
    end
    
    it '未ログイン状態で、ログインできること' do
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
    end
    
    it 'ログイン状態で、ログアウトできること' do
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

      #ログアウトメニューをクリック
      #click_link 'link_menu_logout'
      click_link I18n.t('views.labels.link_menu_logout')
      sleep(0.5)
 
      #ログインページに遷移し, "ログイン"が表示されていることを確認
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
      expect(page).to have_content 'ログイン'
    end

    it '未ログイン状態でサイト一覧画面に飛ぼうとしたとき、ログイン画面に遷移すること' do
      #サイト一覧画面をリクエスト
      visit team_sites_path(team_id: @default_team.id)
      sleep(0.5)

      #ログイン画面に遷移していることを確認
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
      expect(page).to have_content 'ログイン'
    end

    it '未ログイン状態でサイト一覧画面に飛ぼうとしたとき、ログイン画面に遷移し、ログイン認証した後、サイト一覧画面に遷移すること' do
      #サイト一覧画面をリクエスト
      visit team_sites_path(team_id: @default_team.id)
      sleep(0.5)

      #ログイン画面に遷移していることを確認
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
      expect(page).to have_content 'ログイン'

      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: 'default_owner@example.com'
      fill_in "user_password", with: 'passwd'
      click_on "user_login_submit"
      sleep(0.5)
      
      #サイト一覧画面に遷移し、""が表示されていることを確認
      expect(page).to have_content I18n.t('views.labels.site_index')
      #2件のサイト情報が表示されていることを確認
      expect(page).to have_content @site01.name
      expect(page).to have_content @site01.address
      expect(page).to have_content @site01.user.name
      expect(page).to have_content @site02.name
      expect(page).to have_content @site02.address
      expect(page).to have_content @site02.user.name
    end

    it '未ログイン状態でサイト詳細画面に飛ぼうとしたとき、ログイン画面に遷移すること' do
      #サイト詳細画面をリクエスト
      visit team_sites_path(team_id: @default_team.id, id: @site01.id)
      sleep(0.5)

      #ログイン画面に遷移していることを確認
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
      expect(page).to have_content 'ログイン'
    end

    it '未ログイン状態でサイト詳細画面に飛ぼうとしたとき、ログイン画面に遷移し、ログイン認証した後、サイト詳細画面に遷移すること' do
      #サイト一覧画面をリクエスト
      visit team_site_path(team_id: @default_team.id, id: @site01.id)
      sleep(0.5)

      #ログイン画面に遷移していることを確認
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
      expect(page).to have_content 'ログイン'

      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: 'default_owner@example.com'
      fill_in "user_password", with: 'passwd'
      click_on "user_login_submit"
      sleep(0.5)
      
      #サイト詳細画面に遷移し、""が表示されていることを確認
      expect(page).to have_content I18n.t('views.labels.site_show')
      expect(page).to have_content I18n.t('views.labels.site_show_basic_attributes_block')
      expect(page).to have_content I18n.t('views.labels.site_show_map_block')
      expect(page).to have_content I18n.t('views.labels.site_show_comments_block')
      expect(page).to have_content I18n.t('views.labels.site_show_images_block')
      #サイト情報が表示されていることを確認
      expect(page).to have_content @site01.id
      expect(page).to have_content @site01.name
      expect(page).to have_content @site01.address
    end
  end

  describe 'マイページ機能のテスト' do
    before do
    end
    it 'メニューのマイページメニューをクリックするとマイページ画面に遷移すること' do
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

      #マイページ画面をリクエスト
      visit user_path
      sleep(0.5)

      #マイページ画面に遷移していることを確認
      expect(page).to have_content @default_owner.name
      expect(page).to have_content @default_owner.email
      expect(page).to have_content I18n.t('views.messages.team_you_belong_to')
      @default_owner.teams.each { |t| expect(page).to have_content t.name }
    end 

    it 'マイページ画面にてプロフィール編集ができること' do
    end 
  end
end 