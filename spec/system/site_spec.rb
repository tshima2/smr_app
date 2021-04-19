require 'rails_helper'

RSpec.describe 'サイト機能のテスト', type: :system do

  before do
    @default_owner=FactoryBot.create(:default_owner)    #DefaultTeam Owner User
    @default_team=FactoryBot.create(:default_team)      #DefaultTeam, All First User is assigned this team.
    @default_owner.keep_team_id=@default_team.id
    @default_owner.save
  
    @second_user=FactoryBot.create(:second_user)
    @second_team=FactoryBot.create(:team)
    @second_user.keep_team_id=@second_team.id
    @second_user.save

    @asgn11 = @default_team.assigns.build(user_id: @default_owner.id)
    @asgn11.save
    @asgn12 = @second_team.assigns.build(user_id: @default_owner.id)
    @asgn12.save
    @asgn21 = @default_team.assigns.build(user_id: @second_user.id)
    @asgn21.save
    @asgn22 = @second_team.assigns.build(user_id: @second_user.id)
    @asgn22.save

    @site01 = FactoryBot.create(:site, team_id: @default_team.id, user_id: @default_owner.id)
    @site02 = FactoryBot.create(:site, team_id: @default_team.id, user_id: @default_owner.id)
    @site03 = FactoryBot.create(:site, team_id: @default_team.id, user_id: @default_owner.id)
    @site04 = FactoryBot.create(:site, team_id: @default_team.id, user_id: @default_owner.id)
    @site05 = FactoryBot.create(:site, team_id: @default_team.id, user_id: @second_user.id)
    @site06 = FactoryBot.create(:site, team_id: @default_team.id, user_id: @second_user.id)
    @site11 = FactoryBot.create(:site, team_id: @second_team.id, user_id: @second_user.id)
    @site12 = FactoryBot.create(:site, team_id: @second_team.id, user_id: @second_user.id)
    @site13 = FactoryBot.create(:site, team_id: @second_team.id, user_id: @second_user.id)
    @site14 = FactoryBot.create(:site, team_id: @second_team.id, user_id: @second_user.id)

    @comment01 = FactoryBot.create(:comment, user_id: @default_owner.id, site_id: @site11.id)
    @comment02 = FactoryBot.create(:comment, user_id: @second_user.id, site_id: @site11.id)
  end


  describe 'サイト一覧画面のテスト' do
    before do
    end

    it 'メニューのサイト一覧クリックでサイト一覧画面に遷移すること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.5)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
       
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: @second_user.email
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
       
      #サイト情報メニューをクリック
      find('#link_site_index_navitem').click
      sleep(0.5)

      #サイト一覧画面に遷移し、該当チームのサイト6件が表示されていることを確認
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
      expect(page).to have_content @site05.id
      expect(page).to have_content @site05.name
      expect(page).to have_content @site05.address
      expect(page).to have_content @site05.memo 
      expect(page).to have_content @site06.id
      expect(page).to have_content @site06.name
      expect(page).to have_content @site06.address
      expect(page).to have_content @site06.memo 
    end

    it '一覧画面の編集/削除ボタンはチームオーナーもしくはサイト作成者のみ表示されていること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.5)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
       
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: @second_user.email
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
       
      #サイト情報メニューをクリック
      find('#link_site_index_navitem').click
      sleep(0.5)

      #サイト一覧画面に遷移し、該当チームのサイト6件が表示されていることを確認
      expect(page).to have_content I18n.t('views.labels.site_index')

      expect(page).to have_content @site06.id
      expect(page).to have_content @site06.name
      expect(page).to have_content @site06.address
      expect(page).to have_content @site06.memo 
      expect(page).to have_content I18n.t('views.labels.site_index_edit')
      expect(page).to have_content I18n.t('views.labels.site_index_delete')

      expect(page).to have_content @site05.id
      expect(page).to have_content @site05.name
      expect(page).to have_content @site05.address
      expect(page).to have_content @site05.memo 
      expect(page).to have_content I18n.t('views.labels.site_index_edit')
      expect(page).to have_content I18n.t('views.labels.site_index_delete')

      expect(page).to have_content @site04.id
      expect(page).to have_content @site04.name
      expect(page).to have_content @site04.address
      expect(page).to have_content @site04.memo 

      expect(page).to have_content @site03.id
      expect(page).to have_content @site03.name
      expect(page).to have_content @site03.address
      expect(page).to have_content @site03.memo

      expect(page).to have_content @site02.id
      expect(page).to have_content @site02.name
      expect(page).to have_content @site02.address
      expect(page).to have_content @site02.memo

      expect(page).to have_content @site01.id
      expect(page).to have_content @site01.name
      expect(page).to have_content @site01.address
      expect(page).to have_content @site01.memo
    end

    it '一覧画面の新規作成リンククリックで新規作成ページに遷移し、サイトの作成ができること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.5)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
       
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: @second_user.email
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
       
      #サイト情報メニューをクリック
      find('#link_site_index_navitem').click
      sleep(0.5)

      #サイト一覧画面に遷移し、該当チームのサイト6件が表示されていることを確認
      click_link I18n.t('views.labels.link_site_new')
      sleep(0.5)

      #遷移した新しいサイト情報画面で項目を入力し登録ボタン押下
      _name=Faker::Name.last_name; _address=Faker::Address.city; _memo=Faker::Beer.brand
      fill_in "site[name]", with: _name
      fill_in "site[address]", with: _address
      fill_in "site[memo]", with: _memo
      click_on "commit"
      sleep(0.5)

      #遷移先のサイト一覧画面で作成したサイトの情報が表示されていることを確認
      expect(page).to have_content I18n.t('views.labels.site_index')
      expect(page).to have_content _name
      expect(page).to have_content _address
      expect(page).to have_content _memo
    end
  end

  describe 'サイト詳細画面のテスト' do
    before do
    end
    
    it 'サイト詳細画面からコメントの追加ができること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.5)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
             
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: @second_user.email
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
             
      #サイト情報メニューをクリック
      find('#link_site_index_navitem').click
      sleep(0.5)
    
      #site06の詳細画面リンクを押下
      click_link @site06.id.to_s
      sleep(0.5)

      expect(page).to have_content I18n.t('views.labels.site_show')

      #遷移先詳細画面でコメントを入力し追加ボタン押下
      fill_in "comment[content]", with: "shima_shima"
      click_on "commit"
      sleep(0.5)

      #コメント"shima_shima"が表示されていることを確認
      expect(page).to have_content "shima_shima"
    end

    it 'サイト詳細画面のコメント編集/削除ボタンはコメント作成者もしくはチームオーナーのみ表示されていること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.5)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
                   
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: @default_owner.email
      fill_in "user_password", with: 'passwd'
      click_on "user_login_submit"
      sleep(0.5)
                   
      #トップページに遷移し, "ログインしました。"が表示されていることを確認
      expect(page).to have_content 'ログインしました。'
            
      #"マイチーム"ドロップダウンメニューをクリック
      find('#link_myteam_dropdown').click
      sleep(0.5)
            
      #"SecondTeam"をクリック
      click_link @second_team.name
      sleep(0.5)
                   
      #サイト情報メニューをクリック
      find('#link_site_index_navitem').click
      sleep(0.5)
          
      #site06の詳細画面リンクを押下
      click_link @site11.id.to_s
      sleep(0.5)
      
      expect(page).to have_content I18n.t('views.labels.site_show')
      
      #コメントの下に表示されているリンクを取得
      links=all('.site_show_comment_item a')
      #取得したリンクが@comment01の削除/編集ボタンであることを確認
      expect(links[0][:href]).to have_content "comments/#{@comment01.id}/edit"
      expect(links[1][:href]).to have_content "comments/#{@comment01.id}"
      #取得したリンクが@comment02の削除/編集ボタンでないことを確認
      expect(links[0][:href]).not_to have_content "comments/#{@comment02.id}/edit"
      expect(links[1][:href]).not_to have_content "comments/#{@comment02.id}"
    end

    it 'サイト詳細画面から画像追加ができること' do
    end
    it 'サイト詳細画面の画像編集/削除ボタンはコメント作成者もしくはチームオーナーのみ表示されていること' do
    end
  end

  describe '絞り込み検索のテスト' do
    before do
      @comment11=FactoryBot.create(:comment_filter_1, site_id: @site01.id)
      @comment21=FactoryBot.create(:comment_filter_2, site_id: @site02.id)
      @comment22=FactoryBot.create(:comment_filter_3, site_id: @site03.id)
      @comment31=FactoryBot.create(:comment_filter_1, site_id: @site04.id)
      @comment51=FactoryBot.create(:comment_filter_2, site_id: @site05.id)
      @comment61=FactoryBot.create(:comment_filter_3, site_id: @site06.id)
    end

    it 'コメントの一部を入力し、あいまい検索ができること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.5)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
                   
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: @default_owner.email
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
                   
      #サイト情報メニューをクリック
      find('#link_site_index_navitem').click
      sleep(0.5)

      #コメントの一部として"新"を入力
      fill_in "q[comments_content_cont]", with: "新"
      click_on "commit"
      sleep(0.5)

      #絞り込んだ行が"新"を含むコメントを含むサイトであることを確認
      lines=all('.site_index_index table tr td .btn-primary')
      expect(lines[0][:href]).to have_content "sites/#{@site05.id}"
      expect(lines[1][:href]).to have_content "sites/#{@site04.id}"
      expect(lines[2][:href]).to have_content "sites/#{@site02.id}"
      expect(lines[3][:href]).to have_content "sites/#{@site01.id}"
    end 
  end

end 