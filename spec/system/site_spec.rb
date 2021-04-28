require 'rails_helper'

RSpec.describe 'サイト機能のテスト', type: :system do

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

    @image01 = FactoryBot.create(:image_post, user_id: @default_owner.id, site_id: @site14.id)
    @image02 = FactoryBot.create(:image_post, user_id: @second_user.id, site_id: @site14.id)

  end


  describe 'サイト一覧画面のテスト' do
    before do
    end

    it 'メニューのサイト一覧クリックでサイト一覧画面に遷移すること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
       
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: @second_user.email
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
       
      #サイト情報メニューをクリック
      find('#link_site_index_navitem').click
      sleep(0.1)

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
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
       
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: @second_user.email
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
       
      #サイト情報メニューをクリック
      find('#link_site_index_navitem').click
      sleep(0.1)

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

    it 'チームオーナは他者作成サイト編集画面のURLを貼ることにより遷移し編集できること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
       
      #default_ownerがEメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: @default_owner.email
      fill_in "user_password", with: 'passwd'
      click_on "user_login_submit"
      sleep(0.1)

      #second_user作成のサイトid:5の編集画面をvisit
      visit edit_team_site_path(team_id: @site05.team_id, id: @site05.id)
      sleep(0.1)

      #サイトid:5の編集画面に遷移していることを確認
      expect(page).to have_content I18n.t('views.labels.site_edit')
      inputs=all('.container_article input')
      names = inputs.select {|i| i[:name]=="site[name]"}; expect(names[0][:value]).to eq @site05.name
      addresses = inputs.select {|i| i[:name]=="site[address]"}; expect(addresses[0][:value]).to eq @site05.address
      memos = inputs.select {|i| i[:name]=="site[memo]"}; expect(memos[0][:value]).to eq @site05.memo
    end

    it 'チームオーナ以外は他者作成サイト編集画面のURLを貼っても遷移せず編集できないこと' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
       
      #second_userがEメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: @second_user.email
      fill_in "user_password", with: 'passwd'
      click_on "user_login_submit"
      sleep(0.1)

      #default_owner作成のサイトid:1の編集画面をvisit
      visit edit_team_site_path(team_id: @site01.team_id, id: @site01.id)
      sleep(0.1)

      #トップ画面に遷移しエラーメッセージが表示されていることを確認
      expect(page).to have_content I18n.t('views.top.welcome')
      expect(page).to have_content I18n.t('views.messages.unauthorized_request')
    end

    it '一覧画面の新規作成リンククリックで新規作成ページに遷移し、サイトの作成ができること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
       
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: @second_user.email
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
       
      #サイト情報メニューをクリック
      find('#link_site_index_navitem').click
      sleep(0.1)

      #サイト一覧画面に遷移
      click_link I18n.t('views.labels.link_site_new')
      sleep(0.1)

      #遷移した新しいサイト情報画面で項目を入力し登録ボタン押下
      _name=Faker::Name.last_name; _address=Faker::Address.city; _memo=Faker::Beer.brand
      fill_in "site[name]", with: _name
      fill_in "site[address]", with: _address
      fill_in "site[memo]", with: _memo
      click_on "commit"
      sleep(0.1)

      #遷移先のサイト一覧画面で作成したサイトの情報が表示されていることを確認
      expect(page).to have_content I18n.t('views.labels.site_index')
      expect(page).to have_content _name
      expect(page).to have_content _address
      expect(page).to have_content _memo
    end

    it '新規作成で名称が空だと作成できないこと' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
       
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: @second_user.email
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
       
      #サイト情報メニューをクリック
      find('#link_site_index_navitem').click
      sleep(0.1)

      #遷移したサイト一覧画面で新規作成をクリック
      click_link I18n.t('views.labels.link_site_new')
      sleep(0.1)

      #遷移した新しいサイト情報画面で、空の名称を入力し登録ボタン押下
      #_name=Faker::Name.last_name; _address=Faker::Address.city; _memo=Faker::Beer.brand
      _name=""; _address=Faker::Address.city; _memo=Faker::Beer.brand
      fill_in "site[name]", with: _name
      fill_in "site[address]", with: _address
      fill_in "site[memo]", with: _memo
      click_on "commit"
      sleep(0.1)
      
      #遷移した確認画面にて登録ボタン押下
      click_on I18n.t('views.labels.site_submit')
      sleep(0.1)

      #新規作成画面でのエラー表示を確認
      expect(page).to have_content I18n.t('views.messages.failed_create_site')
      expect(page).to have_content "Nameを入力してください"      
    end

    it '新規作成で２５５文字以上の名称を入力すると作成できないこと' do
          #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
       
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: @second_user.email
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
       
      #サイト情報メニューをクリック
      find('#link_site_index_navitem').click
      sleep(0.1)

      #遷移したサイト一覧画面で新規作成をクリック
      click_link I18n.t('views.labels.link_site_new')
      sleep(0.1)

      #遷移した新しいサイト情報画面で、空の名称を入力し登録ボタン押下
      #_name=Faker::Name.last_name; _address=Faker::Address.city; _memo=Faker::Beer.brand
      _name=""; 130.times.each { _name += (('a'..'z').to_a.sample) }; _address=Faker::Address.city; _memo=Faker::Beer.brand      
      fill_in "site[name]", with: _name
      fill_in "site[address]", with: _address
      fill_in "site[memo]", with: _memo
      click_on "commit"
      sleep(0.1)

      #遷移した確認画面にて登録ボタン押下
      click_on I18n.t('views.labels.site_submit')
      sleep(0.1)

      #新規作成画面でのエラー表示を確認
      expect(page).to have_content I18n.t('views.messages.failed_create_site')
      expect(page).to have_content "Nameは128文字以内で入力してください"  
    end

    it '新規作成で住所が空だと作成できないこと' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
           
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: @second_user.email
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
           
      #サイト情報メニューをクリック
      find('#link_site_index_navitem').click
      sleep(0.1)
    
      #遷移したサイト一覧画面で新規作成をクリック
      click_link I18n.t('views.labels.link_site_new')
      sleep(0.1)
    
      #遷移した新しいサイト情報画面で、空の名称を入力し登録ボタン押下
      #_name=Faker::Name.last_name; _address=Faker::Address.city; _memo=Faker::Beer.brand
      _name=Faker::Name.last_name; _address=""; _memo=Faker::Beer.brand
      fill_in "site[name]", with: _name
      fill_in "site[address]", with: _address
      fill_in "site[memo]", with: _memo
      click_on "commit"
      sleep(0.1)
    
      #遷移した確認画面にて登録ボタン押下
      click_on I18n.t('views.labels.site_submit')
      sleep(0.1)

      #新規作成画面でのエラー表示を確認
      expect(page).to have_content I18n.t('views.messages.failed_create_site')
      expect(page).to have_content "Addressを入力してください"
          
    end
    
    it '新規作成で２５５文字以上の住所を入力すると作成できないこと' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
           
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: @second_user.email
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
           
      #サイト情報メニューをクリック
      find('#link_site_index_navitem').click
      sleep(0.1)
    
      #遷移したサイト一覧画面で新規作成をクリック
      click_link I18n.t('views.labels.link_site_new')
      sleep(0.1)
    
      #遷移した新しいサイト情報画面で、空の名称を入力し登録ボタン押下
      #_name=Faker::Name.last_name; _address=Faker::Address.city; _memo=Faker::Beer.brand
      _name=Faker::Name.last_name; _address=""; 256.times.each { _address += (('a'..'z').to_a.sample) }; _memo=Faker::Beer.brand
      fill_in "site[name]", with: _name
      fill_in "site[address]", with: _address
      fill_in "site[memo]", with: _memo
      click_on "commit"
      sleep(0.1)
    
      #遷移した確認画面にて登録ボタン押下
      click_on I18n.t('views.labels.site_submit')
      sleep(0.1)

      #新規作成画面でのエラー表示を確認
      expect(page).to have_content I18n.t('views.messages.failed_create_site')
      expect(page).to have_content "Addressは255文字以内で入力してください"      
    end
    
    it '新規作成で２５５文字以上のメモを入力すると作成できないこと' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
           
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: @second_user.email
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
           
      #サイト情報メニューをクリック
      find('#link_site_index_navitem').click
      sleep(0.1)
    
      #遷移したサイト一覧画面で新規作成をクリック
      click_link I18n.t('views.labels.link_site_new')
      sleep(0.1)
    
      #遷移した新しいサイト情報画面で、空の名称を入力し登録ボタン押下
      #_name=Faker::Name.last_name; _address=Faker::Address.city; _memo=Faker::Beer.brand
      _name=Faker::Name.last_name; _address=Faker::Address.city; _memo=""; 256.times.each { _memo += (('a'..'z').to_a.sample) }
      fill_in "site[name]", with: _name
      fill_in "site[address]", with: _address
      fill_in "site[memo]", with: _memo
      click_on "commit"
      sleep(0.1)
    
      #遷移した確認画面にて登録ボタン押下
      click_on I18n.t('views.labels.site_submit')
      sleep(0.1)

      #新規作成画面でのエラー表示を確認
      expect(page).to have_content I18n.t('views.messages.failed_create_site')
      expect(page).to have_content "Memoは255文字以内で入力してください" 
    end

  end

  describe 'サイト詳細画面のテスト' do
    before do
    end
    
    it 'サイト詳細画面からコメントの追加ができること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
             
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: @second_user.email
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
             
      #サイト情報メニューをクリック
      find('#link_site_index_navitem').click
      sleep(0.1)
    
      #site06の詳細画面リンクを押下
      click_link @site06.id.to_s
      sleep(0.1)

      expect(page).to have_content I18n.t('views.labels.site_show')

      #遷移先詳細画面でコメントを入力し追加ボタン押下
      fill_in "comment[content]", with: "shima_shima"
      click_on "commit"
      sleep(0.1)

      #コメント"shima_shima"が表示されていることを確認
      expect(page).to have_content "shima_shima"
    end

    it 'サイト詳細画面のコメント編集/削除ボタンはコメント作成者もしくはチームオーナーのみ表示されていること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
                   
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: @default_owner.email
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
                   
      #サイト情報メニューをクリック
      find('#link_site_index_navitem').click
      sleep(0.1)
          
      #site11の詳細画面リンクを押下
      click_link @site11.id.to_s
      sleep(0.1)
      
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

    it '1024文字以上のコメントを入力すると追加できないこと' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
             
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: @second_user.email
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
             
      #サイト情報メニューをクリック
      find('#link_site_index_navitem').click
      sleep(0.1)
    
      #site06の詳細画面リンクを押下
      click_link @site06.id.to_s
      sleep(0.1)

      expect(page).to have_content I18n.t('views.labels.site_show')

      #遷移先詳細画面でコメントを入力し追加ボタン押下
      _comment=""; 1025.times.each { _comment += (('a'..'z').to_a.sample) }
      fill_in "comment[content]", with: _comment
      click_on "commit"
      sleep(0.1)

      #エラーメッセージと内容が表示されていることを確認
      expect(page).to have_content I18n.t('views.messages.failed_to_post_comment')
    end

    it 'コメントの更新が出来ること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
                   
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: @default_owner.email
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
                   
      #サイト情報メニューをクリック
      find('#link_site_index_navitem').click
      sleep(0.1)
          
      #site11の詳細画面リンクを押下
      click_link @site11.id.to_s
      sleep(0.1)
      
      expect(page).to have_content I18n.t('views.labels.site_show')
      
      #コメントの下に表示されているリンクを取得
      links=all('.site_show_comment_item a')
      #取得したリンクが@comment01の削除/編集ボタンであることを確認
      expect(links[0][:href]).to have_content "comments/#{@comment01.id}/edit"
      expect(links[1][:href]).to have_content "comments/#{@comment01.id}"

      #編集ボタン押下
      find("#this_comment_#{@comment01.id} a").click
      sleep(0.1)
      
      find_by_id("comment_content_#{@comment01.site_id}").fill_in with: 'test'
      submits=find_by_id("comment_submit_#{@comment01.site_id}")
      click_on submits.value
      sleep(0.1)

      expect(page).to have_content I18n.t('views.messages.update_comment')
    end

    it 'コメントの削除が出来ること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
                   
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: @default_owner.email
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
                   
      #サイト情報メニューをクリック
      find('#link_site_index_navitem').click
      sleep(0.1)
          
      #site11の詳細画面リンクを押下
      click_link @site11.id.to_s
      sleep(0.1)
      
      expect(page).to have_content I18n.t('views.labels.site_show')
      
      #コメントの下に表示されているリンクを取得
      links=all('.site_show_comment_item a')
      #取得したリンクが@comment01の削除/編集ボタンであることを確認
      expect(links[0][:href]).to have_content "comments/#{@comment01.id}/edit"
      expect(links[1][:href]).to have_content "comments/#{@comment01.id}"

      #削除ボタン押下
      #click_link I18n.t('views.labels.comment_delete')
      links[1].click
      sleep(0.1)

      #alertダイアログでOKを選択する
      page.driver.browser.switch_to.alert.accept
      sleep(0.1)

      expect(page).to have_content I18n.t('views.messages.delete_comment')
    end

    it 'サイト詳細画面から画像追加ができること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
             
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: @second_user.email
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
             
      #サイト情報メニューをクリック
      find('#link_site_index_navitem').click
      sleep(0.1)
    
      #site06の詳細画面リンクを押下
      click_link @site06.id.to_s
      sleep(0.1)

      #遷移先詳細画面で"画像を追加する"リンクをクリック
      expect(page).to have_content I18n.t('views.labels.site_show')
      click_link I18n.t('views.labels.link_add_image')
      sleep(0.1)
      expect(page).to have_content I18n.t('views.labels.create_image_post')

      #画像を追加し更新ボタン押下
      image_path = File.join(Rails.root, "spec/factories/images/shima.PNG")
      find('#image_post_image').set(image_path)
      click_on I18n.t('views.button.submit')
      sleep(0.1)

      expect(page).to have_content I18n.t('views.messages.create_image_post')
      expect(page).to have_selector("img[src$='shima.PNG']")
    end

    it '画像ファイルを指定しないと投稿できないこと' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
             
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: @second_user.email
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
             
      #サイト情報メニューをクリック
      find('#link_site_index_navitem').click
      sleep(0.1)
    
      #site06の詳細画面リンクを押下
      click_link @site06.id.to_s
      sleep(0.1)

      #遷移先詳細画面で"画像を追加する"リンクをクリック
      expect(page).to have_content I18n.t('views.labels.site_show')
      click_link I18n.t('views.labels.link_add_image')
      sleep(0.1)
      expect(page).to have_content I18n.t('views.labels.create_image_post')

      #画像を追加しないで更新ボタン押下
      click_on I18n.t('views.button.submit')
      sleep(0.1)

      #エラーメッセージ表示を確認
      expect(page).to have_content I18n.t('views.messages.failed_create_image_post')
    end

    it 'サイト詳細画面の画像編集/削除ボタンは画像作成者もしくはチームオーナーのみ表示されていること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
                   
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: @default_owner.email
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
                   
      #サイト情報メニューをクリック
      find('#link_site_index_navitem').click
      sleep(0.1)
          
      #site14の詳細画面リンクを押下
      click_link @site14.id.to_s
      sleep(0.1)
      
      expect(page).to have_content I18n.t('views.labels.site_show')
      
      #画像の下に表示されているリンクを取得
      links=all('.site_show_menu_on_image .site_show_menu a')
      sleep(0.1)
      
      #取得したリンクが@image01の削除ボタンであることを確認
      expect(links[0][:href]).to have_content "image_posts/#{@image01.id}"
      #取得したリンクが@image02の削除ボタンでないことを確認
      expect(links[0][:href]).not_to have_content "image_posts/#{@image02.id}"
    end

    it 'サイト詳細画面から画像削除ができること' do
      #Sign in 画面に遷移
      visit new_user_session_path
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
                   
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: @default_owner.email
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
                   
      #サイト情報メニューをクリック
      find('#link_site_index_navitem').click
      sleep(0.1)
          
      #site14の詳細画面リンクを押下
      click_link @site14.id.to_s
      sleep(0.1)
      
      expect(page).to have_content I18n.t('views.labels.site_show')
      
      #画像の下に表示されているリンクを取得
      links=all('.site_show_menu_on_image .site_show_menu a')
      sleep(0.1)
      
      #取得したリンクが@image01の削除ボタンであることを確認
      expect(links[0][:href]).to have_content "image_posts/#{@image01.id}"

      #image01の削除ボタンを押下
      links[0].click
      sleep(0.1)
    
      #alertダイアログでOKを選択する
      page.driver.browser.switch_to.alert.accept
      sleep(0.1)

      expect(page).to have_content I18n.t('views.messages.delete_image_post')
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
      sleep(0.1)
      expect(page).to have_content I18n.t('devise.sessions.new.sign_in')
                   
      #Eメール, パスワードを打ち込み, "ログイン"ボタン押下
      fill_in "user_email", with: @default_owner.email
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
                   
      #サイト情報メニューをクリック
      find('#link_site_index_navitem').click
      sleep(0.1)

      #コメントの一部として"新"を入力
      fill_in "q[comments_content_cont]", with: "新"
      click_on "commit"
      sleep(0.1)

      #絞り込んだ行が"新"を含むコメントを含むサイトであることを確認
      lines=all('.site_index_index table tr td .btn-primary')
      expect(lines[0][:href]).to have_content "sites/#{@site05.id}"
      expect(lines[1][:href]).to have_content "sites/#{@site04.id}"
      expect(lines[2][:href]).to have_content "sites/#{@site02.id}"
      expect(lines[3][:href]).to have_content "sites/#{@site01.id}"
    end 
  end

end 