require 'rails_helper'

RSpec.describe 'チーム機能のテスト', type: :system do

  before do
    @default_owner=FactoryBot.create(:default_owner)    #DefaultTeam Owner User
    @default_team=FactoryBot.create(:default_team)      #DefaultTeam, All First User is assigned this team.
    @default_owner.keep_team_id=@default_team.id
    @default_owner.save

    @second_user=FactoryBot.create(:second_user)
    @second_team=FactoryBot.create(:second_team)
    @second_user.keep_team_id=@second_team.id
    @second_user.save
   
    @asgn11 = @default_team.assigns.build(user_id: @default_owner.id)
    @asgn11.save
    #@asgn12 = @default_team.assigns.build(user_id: @second_user.id)
    #@asgn12.save
    @asgn21 = @second_team.assigns.build(user_id: @default_owner.id)
    @asgn21.save
    @asgn22 = @second_team.assigns.build(user_id: @second_user.id)
    @asgn22.save

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
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
      
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: 'default_owner@example.com'
      fill_in "user_password", with: 'passwd'
      click_on "user_login_submit"
      sleep(0.1)
      
      #トップページに遷移し, "ログインしました。"が表示されていることを確認
      expect(page).to have_content 'ログインしました。'

      #"マイチーム"ドロップダウンメニューをクリック
      #click_link I18n.t('views.labels.link_menu_my_team')
      find('#link_myteam_dropdown').click
      sleep(0.1)

      #"あたらしくチームを作る"メニューをクリック
      click_link I18n.t('views.labels.link_menu_new_team')
      sleep(0.1)

      #新しいチーム画面に遷移していることを確認
      expect(page).to have_content I18n.t('views.messages.team_build')
    end

    it 'チーム作成画面でチーム作成ができること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
      
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: 'default_owner@example.com'
      fill_in "user_password", with: 'passwd'
      click_on "user_login_submit"
      sleep(0.1)
      
      #トップページに遷移し, "ログインしました。"が表示されていることを確認
      expect(page).to have_content 'ログインしました。'

      #"マイチーム"ドロップダウンメニューをクリック
      #click_link I18n.t('views.labels.link_menu_my_team')
      find('#link_myteam_dropdown').click
      sleep(0.1)

      #"あたらしくチームを作る"メニューをクリック
      click_link I18n.t('views.labels.link_menu_new_team')
      sleep(0.1)

      #新しいチーム画面に遷移していることを確認
      expect(page).to have_content I18n.t('views.messages.team_build')

      #チーム名とアイコンを入力し作成ボタン押下
      fill_in "team[name]", with: 'TestTeam'
      image_path = File.join(Rails.root, "spec/factories/images/shima.PNG")
      find('#team_icon').set(image_path)
      click_on "commit"
      sleep(0.1)

      #チーム詳細ページに遷移しチームが作成されたメッセージとチームアイコンが表示されていることを確認
      expect(page).to have_content I18n.t('views.messages.create_team')
      expect(page).to have_content 'TestTeam'
      expect(page).to have_selector("img[src$='shima.PNG']")      
    end
    
    it '空の名称を入力するとチーム作成に失敗すること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
      
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: 'default_owner@example.com'
      fill_in "user_password", with: 'passwd'
      click_on "user_login_submit"
      sleep(0.1)
      
      #トップページに遷移し, "ログインしました。"が表示されていることを確認
      expect(page).to have_content 'ログインしました。'

      #"マイチーム"ドロップダウンメニューをクリック
      #click_link I18n.t('views.labels.link_menu_my_team')
      find('#link_myteam_dropdown').click
      sleep(0.1)

      #"あたらしくチームを作る"メニューをクリック
      click_link I18n.t('views.labels.link_menu_new_team')
      sleep(0.1)

      #新しいチーム画面に遷移していることを確認
      expect(page).to have_content I18n.t('views.messages.team_build')

      #チーム名とアイコンを入力し作成ボタン押下
      fill_in "team[name]", with: ''
      image_path = File.join(Rails.root, "spec/factories/images/shima.PNG")
      find('#team_icon').set(image_path)
      click_on "commit"
      sleep(0.1)

      #チーム詳細ページに遷移しチームが作成されたメッセージとチームアイコンが表示されていることを確認
      expect(page).to have_content I18n.t('views.messages.failed_to_save_team')
      expect(page).to have_content "Nameを入力してください"
      expect(page).not_to have_selector("img[src$='shima.PNG']")      
    end

    it '128文字以上の名称を入力するとチーム作成に失敗すること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
      
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: 'default_owner@example.com'
      fill_in "user_password", with: 'passwd'
      click_on "user_login_submit"
      sleep(0.1)
      
      #トップページに遷移し, "ログインしました。"が表示されていることを確認
      expect(page).to have_content 'ログインしました。'

      #"マイチーム"ドロップダウンメニューをクリック
      #click_link I18n.t('views.labels.link_menu_my_team')
      find('#link_myteam_dropdown').click
      sleep(0.1)

      #"あたらしくチームを作る"メニューをクリック
      click_link I18n.t('views.labels.link_menu_new_team')
      sleep(0.1)

      #新しいチーム画面に遷移していることを確認
      expect(page).to have_content I18n.t('views.messages.team_build')

      #チーム名とアイコンを入力し作成ボタン押下
      _name=""; 130.times.each { _name += (('a'..'z').to_a.sample) }
      fill_in "team[name]", with: _name
      image_path = File.join(Rails.root, "spec/factories/images/shima.PNG")
      find('#team_icon').set(image_path)
      click_on "commit"
      sleep(0.1)
      
      #チーム詳細ページに遷移しチームが作成されたメッセージとチームアイコンが表示されていることを確認
      expect(page).to have_content I18n.t('views.messages.failed_to_save_team')
      expect(page).to have_content "Nameは128文字以内で入力してください"
      expect(page).not_to have_selector("img[src$='shima.PNG']")      
    end
  end

  describe 'チーム選択機能のテスト' do
    before do
    end
    
    it 'メニューのチーム選択メニュークリックでチーム詳細画面に遷移すること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
      
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: 'default_owner@example.com'
      fill_in "user_password", with: 'passwd'
      click_on "user_login_submit"
      sleep(0.1)
      
      #トップページに遷移し, "ログインしました。"が表示されていることを確認
      expect(page).to have_content 'ログインしました。'

      #"マイチーム"ドロップダウンメニューをクリック
      find('#link_myteam_dropdown').click
      sleep(0.1)

      #"DefaultTeam"をクリック
      click_link @default_team.name
      sleep(0.1)

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
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
      
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: 'default_owner@example.com'
      fill_in "user_password", with: 'passwd'
      click_on "user_login_submit"
      sleep(0.1)
      
      #トップページに遷移し, "ログインしました。"が表示されていることを確認
      expect(page).to have_content 'ログインしました。'

      #"マイチーム"ドロップダウンメニューをクリック
      find('#link_myteam_dropdown').click
      sleep(0.1)

      #"DefaultTeam"をクリック
      click_link @default_team.name
      sleep(0.1)

      #再度"マイチーム"ドロップダウンメニューをクリック
      find('#link_myteam_dropdown').click
      sleep(0.1)
      
      #さっき選択した"DefaultTeam"の前のアイコンがチェック済（fa-check-square）になっていること
      elems = all('.dropdown-item span i')
      expect(elems[0][:class]).to have_content 'fas fa-check-square'
      expect(elems[1][:class]).to have_content 'far fa-square'

    end

    it '選択したチームに応じたサイト一覧が表示されていること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
      
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: 'default_owner@example.com'
      fill_in "user_password", with: 'passwd'
      click_on "user_login_submit"
      sleep(0.1)
      
      #トップページに遷移し, "ログインしました。"が表示されていることを確認
      expect(page).to have_content 'ログインしました。'

      #"マイチーム"ドロップダウンメニューをクリック
      find('#link_myteam_dropdown').click
      sleep(0.1)

      #"DefaultTeam"をクリック
      click_link @default_team.name
      sleep(0.1)

      #サイト一覧に遷移
      visit team_sites_path(@default_team.id)
      sleep(0.1)

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
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
      
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: 'default_owner@example.com'
      fill_in "user_password", with: 'passwd'
      click_on "user_login_submit"
      sleep(0.1)
      
      #トップページに遷移し, "ログインしました。"が表示されていることを確認
      expect(page).to have_content 'ログインしました。'

      #"マイチーム"ドロップダウンメニューをクリック
      find('#link_myteam_dropdown').click
      sleep(0.1)

      #"DefaultTeam"をクリック
      click_link @default_team.name
      sleep(0.1)

      #チームメンバーに"second_user"が居ないことを確認
      expect(page).not_to have_content "#{@second_user.name} <#{@second_user.email}>"

      #"second_user"のメールを入力し招待ボタン押下
      fill_in "email", with: @second_user.email
      click_on I18n.t('views.button.invite')
      sleep(0.1)

      #チームメンバーに"second_user"の名前とメールが表示されていることを確認
      expect(page).to have_content I18n.t('views.messages.assigned')
      expect(page).to have_content "#{@second_user.name} <#{@second_user.email}>"
    end 

    #it 'メンバー招待すると招待されたメンバーに確認メールが飛ぶこと' do
    #end 

    it 'マイチーム画面にてメンバー削除できること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
      
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: 'second_user@example.com'
      fill_in "user_password", with: 'passwd'
      click_on "user_login_submit"
      sleep(0.1)
      
      #トップページに遷移し, "ログインしました。"が表示されていることを確認
      expect(page).to have_content 'ログインしました。'

      #"マイチーム"ドロップダウンメニューをクリック
      find('#link_myteam_dropdown').click
      sleep(0.1)

      #"SecondTeam"をクリック
      click_link @second_team.name
      sleep(0.1)

      #チームメンバーに"default_owner"が居ることを確認
      expect(page).to have_content "#{@default_owner.name} <#{@default_owner.email}>"

      #"default_owner"の削除ボタン押下
      links=all('.btn-danger')
      links = links.select { |li| li[:href].include?("/teams/#{@second_team.id}/assigns/#{@asgn21.id}") }
      links[0].click
      sleep(0.1)

      #チームメンバーに"default_owner"の名前とメールが居ないことを確認
      expect(page).to have_content I18n.t('views.messages.delete_member')
      expect(page).not_to have_content "#{@default_owner.name} <#{@default_owner.email}>"
    end 

    #it 'メンバー削除すると招待されたメンバーに確認メールが飛ぶこと' do
    #end 

    it 'チームオーナの場合はチームプロフィールの編集が出来ること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
      
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: 'second_user@example.com'
      fill_in "user_password", with: 'passwd'
      click_on "user_login_submit"
      sleep(0.1)
      
      #トップページに遷移し, "ログインしました。"が表示されていることを確認
      expect(page).to have_content 'ログインしました。'

      #"マイチーム"ドロップダウンメニューをクリック
      find('#link_myteam_dropdown').click
      sleep(0.1)

      #"SecondTeam"をクリック
      click_link @second_team.name
      sleep(0.1)

      #"チームを編集する"ボタンをクリック
      click_link I18n.t('views.messages.edit_team')
      sleep(0.1)

      #チームを編集する画面に遷移していることを確認
      expect(page).to have_content I18n.t('views.messages.edit_team')

      #チーム名とアイコンを入力し作成ボタン押下
      fill_in "team[name]", with: 'TestTeam2'
      image_path = File.join(Rails.root, "spec/factories/images/default.jpg")
      find('#team_icon').set(image_path)
      click_on "commit"
      sleep(0.1)

      #チーム詳細ページに遷移しチームが作成されたメッセージとチームアイコンが表示されていることを確認
      expect(page).to have_content I18n.t('views.messages.edit_team')
      expect(page).to have_content 'TestTeam2'
      expect(page).to have_selector("img[src$='default.jpg']")      

    end 

    it '空の名前を入力すると更新できないこと' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
      
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: 'second_user@example.com'
      fill_in "user_password", with: 'passwd'
      click_on "user_login_submit"
      sleep(0.1)
      
      #トップページに遷移し, "ログインしました。"が表示されていることを確認
      expect(page).to have_content 'ログインしました。'

      #"マイチーム"ドロップダウンメニューをクリック
      find('#link_myteam_dropdown').click
      sleep(0.1)

      #"SecondTeam"をクリック
      click_link @second_team.name
      sleep(0.1)

      #"チームを編集する"ボタンをクリック
      click_link I18n.t('views.messages.edit_team')
      sleep(0.1)

      #チームを編集する画面に遷移していることを確認
      expect(page).to have_content I18n.t('views.messages.edit_team')

      #空のチーム名とアイコンを入力し作成ボタン押下
      fill_in "team[name]", with: ''
      image_path = File.join(Rails.root, "spec/factories/images/default.jpg")
      find('#team_icon').set(image_path)
      click_on "commit"
      sleep(0.1)

      #エラーメッセージを確認
      expect(page).to have_content I18n.t('views.messages.failed_to_save_team')
      expect(page).to have_content "Nameを入力してください"
    end 

    it '１２８文字以上の名前を入力すると更新できないこと' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
      
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: 'second_user@example.com'
      fill_in "user_password", with: 'passwd'
      click_on "user_login_submit"
      sleep(0.1)
      
      #トップページに遷移し, "ログインしました。"が表示されていることを確認
      expect(page).to have_content 'ログインしました。'

      #"マイチーム"ドロップダウンメニューをクリック
      find('#link_myteam_dropdown').click
      sleep(0.1)

      #"SecondTeam"をクリック
      click_link @second_team.name
      sleep(0.1)

      #"チームを編集する"ボタンをクリック
      click_link I18n.t('views.messages.edit_team')
      sleep(0.1)

      #チームを編集する画面に遷移していることを確認
      expect(page).to have_content I18n.t('views.messages.edit_team')

      #128文字以上のチーム名とアイコンを入力し作成ボタン押下
      _name=""; 130.times.each { _name += (('a'..'z').to_a.sample) }
      fill_in "team[name]", with: _name
      image_path = File.join(Rails.root, "spec/factories/images/default.jpg")
      find('#team_icon').set(image_path)
      click_on "commit"
      sleep(0.1)

      #エラーメッセージを確認
      expect(page).to have_content I18n.t('views.messages.failed_to_save_team')
      expect(page).to have_content "Nameは128文字以内で入力してください"
    end 
  end

end 