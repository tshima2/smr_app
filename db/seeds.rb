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
_name = "Teamタツキ"
team02=Team.create!(name: _name, owner_id: user02.id)
_name = "Team山陽"
team03=Team.create!(name: _name, owner_id: user03.id)

# create Assign
Assign.create!(user_id: user01.id, team_id: team01.id)
Assign.create!(user_id: user02.id, team_id: team01.id)
Assign.create!(user_id: user03.id, team_id: team01.id)
Assign.create!(user_id: user04.id, team_id: team01.id)
Assign.create!(user_id: user02.id, team_id: team02.id)
Assign.create!(user_id: user03.id, team_id: team02.id)
Assign.create!(user_id: user03.id, team_id: team03.id)
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

# create Comment
=begin
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
=end
