# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# create User
_name = "test01"; _email= "test01@example.com"; _pass="passwd"; _keep_team_id = 1
user01=User.create!(name: _name, email: _email, password: _pass, keep_team_id:  _keep_team_id)
_name = "test02"; _email= "test02@example.com"; _pass="passwd"; _keep_team_id = 1
user02=User.create!(name: _name, email: _email, password: _pass, keep_team_id:  _keep_team_id)
_name = "test03"; _email= "test03@example.com"; _pass="passwd"; _keep_team_id = 1
user03=User.create!(name: _name, email: _email, password: _pass, keep_team_id:  _keep_team_id)
_name = "test04"; _email= "test04@example.com"; _pass="passwd"; _keep_team_id = 1
user04=User.create!(name: _name, email: _email, password: _pass, keep_team_id:  _keep_team_id)

# create Team
_name = "DefaultTeam"
team01=Team.create!(name: _name, owner_id: user01.id)
_name = "T輸送"
team02=Team.create!(name: _name, owner_id: user02.id)
_name = "S重機"
team03=Team.create!(name: _name, owner_id: user03.id)

# create Assign
Assign.create!(user_id: user01.id, team_id: team01.id)
Assign.create!(user_id: user02.id, team_id: team01.id)
Assign.create!(user_id: user03.id, team_id: team01.id)
Assign.create!(user_id: user04.id, team_id: team01.id)
Assign.create!(user_id: user02.id, team_id: team02.id)
Assign.create!(user_id: user03.id, team_id: team03.id)
Assign.create!(user_id: user04.id, team_id: team02.id)
Assign.create!(user_id: user04.id, team_id: team03.id)

# create Site
_name="202109xx建方工事（船橋市）"; _address="船橋市前原西7丁目11-4"; _memo="memo01"
site01=Site.create!(user_id: user04.id, team_id: team02.id, name: _name, address: _address, memo: _memo)
_name="202110xx積替地（コインP）"; _address="大田区東蒲田1丁目10"; _memo="memo02"
site02=Site.create!(user_id: user02.id, team_id: team02.id, name: _name, address: _address, memo: _memo)
_name="新宿アルタ前"; _address="新宿区新宿3-18"; _memo="memo03"
site03=Site.create!(user_id: user03.id, team_id: team03.id, name: _name, address: _address, memo: _memo)
_name="新橋ＳＬ広場前"; _address="港区新橋2丁目7"; _memo="memo04"
site04=Site.create!(user_id: user03.id, team_id: team03.id, name: _name, address: _address, memo: _memo)
_name="池袋駅北口"; _address="豊島区南池袋1-28"; _memo="memo05"
site05=Site.create!(user_id: user03.id, team_id: team03.id, name: _name, address: _address, memo: _memo)
_name="小島新田公園"; _address="川崎区田町3-11-1"; _memo="memo06"
site06=Site.create!(user_id: user04.id, team_id: team03.id, name: _name, address: _address, memo: _memo)

require "csv"
comments_header=[
    "男性トイレ総数","男性トイレ数（小便器）","男性トイレ数（和式）","男性トイレ数（洋式）","女性トイレ総数",
    "女性トイレ数（和式）","女性トイレ数（洋式）","男女共用トイレ総数","男女共用トイレ数（和式）","男女共用トイレ数（洋式）",
    "多機能トイレ","車椅子使用者用トイレ有無","乳幼児用設備設置トイレ有無","オストメイト設置トイレ有無","利用開始時間",
    "利用終了時間","利用可能時間特記事項","画像","画像_ライセンス","URL"]

CSV.foreach('db/131130_public_toilet.csv', headers: true) do |row|
    _site = user01.sites.build(team_id: team01.id, name: row["名称"], address: row["住所"], latitude: row["緯度"], longtitude: row["経度"])
  
    if _site.save
        _contents = comments_header.map { |ch| "#{ch}: #{row[ch]}" if row[ch] && row[ch].length>0 }
        _contents.compact.each do |_content|
            _comment = _site.comments.build(content: _content, user_id: user01.id)
            _comment.save!
        end

        if !(_la = Label.find_by(title: "多機能トイレ", team_id: _site.team_id))
            _la = Label.create(title: "多機能トイレ", team_id: _site.team_id)
        end
        if(row["多機能トイレ"]=="有")
            _labelling = _site.site_labellings.build(label_id: _la.id)
            _labelling.save!
        end 
    end
end
    


# create Comment
_content = "Googleマイマップ案内図→　https://www.google.com/maps/d/edit?mid=1kUIUniMq5Eghbk7jcKE0Wr8n1EobSGhs&usp=sharing"
Comment.create!(user_id: user02.id, site_id: site01.id, content: _content)
_content="現場入口が狭いので気をつけて"
Comment.create!(user_id: user02.id, site_id: site01.id, content: _content)
_content="念のため枕木を持参して下さい"
Comment.create!(user_id: user02.id, site_id: site02.id, content: _content)
_content="前原団地入口交差点を左折のこと。踏切の手前まで進んで左折するとスクールゾーンのため"
Comment.create!(user_id: user02.id, site_id: site01.id, content: _content)
_content="右折信号が短いため大型車が並ぶと要注意"
Comment.create!(user_id: user03.id, site_id: site06.id, content: _content)
_content="中型（3t以内）は大師橋を渡ってすぐの信号を左折可能"
Comment.create!(user_id: user03.id, site_id: site06.id, content: _content)

# create ImagePost
ImagePost.create!(image: File.open("#{Rails.root.to_s}/public/images_for_seed/#{rand(1..7)}.jpg"), user_id: user02.id, site_id: site01.id)
ImagePost.create!(image: File.open("#{Rails.root.to_s}/public/images_for_seed/#{rand(1..7)}.jpg"), user_id: user02.id, site_id: site01.id)
ImagePost.create!(image: File.open("#{Rails.root.to_s}/public/images_for_seed/#{rand(1..7)}.jpg"), user_id: user02.id, site_id: site01.id)
ImagePost.create!(image: File.open("#{Rails.root.to_s}/public/images_for_seed/#{rand(1..7)}.jpg"), user_id: user02.id, site_id: site01.id)
ImagePost.create!(image: File.open("#{Rails.root.to_s}/public/images_for_seed/#{rand(1..7)}.jpg"), user_id: user04.id, site_id: site02.id)
ImagePost.create!(image: File.open("#{Rails.root.to_s}/public/images_for_seed/#{rand(1..7)}.jpg"), user_id: user04.id, site_id: site02.id)
ImagePost.create!(image: File.open("#{Rails.root.to_s}/public/images_for_seed/#{rand(1..7)}.jpg"), user_id: user03.id, site_id: site05.id)
ImagePost.create!(image: File.open("#{Rails.root.to_s}/public/images_for_seed/#{rand(1..7)}.jpg"), user_id: user04.id, site_id: site06.id)
ImagePost.create!(image: File.open("#{Rails.root.to_s}/public/images_for_seed/#{rand(1..7)}.jpg"), user_id: user04.id, site_id: site06.id)

# create Label
_title="車庫"; label01=Label.create!(team_id: team02.id, title: _title)
_title="事務所"; label02=Label.create!(team_id: team02.id, title: _title)
_title="借地"; label03=Label.create!(team_id: team02.id, title: _title)
_title="建築地"; label04=Label.create!(team_id: team02.id, title: _title)
_title="S社"; label05=Label.create!(team_id: team03.id, title: _title)
_title="A社"; label06=Label.create!(team_id: team03.id, title: _title)
_title="T社"; label07=Label.create!(team_id: team03.id, title: _title)

# create SiteLabelling
SiteLabelling.create!(site_id: site01.id, label_id: label04.id)
SiteLabelling.create!(site_id: site02.id, label_id: label03.id)
SiteLabelling.create!(site_id: site03.id, label_id: label05.id)
SiteLabelling.create!(site_id: site03.id, label_id: label07.id)
SiteLabelling.create!(site_id: site04.id, label_id: label06.id)

# create Tag
site01.tag_list.add("#R357")
site01.tag_list.add("#R298")
site01.tag_list.add("#成田街道入口")
site01.tag_list.add("#前原団地入口")
site01.save
site06.tag_list.add("#殿町三丁目")
site06.save
