# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

_name = "system"; _email= "system@example.com"; _pass="passwd"; _keep_team_id = nil
sys_user=User.create!(name: _name, email: _email, password: _pass)
_name = "test01"; _email= "test01@example.com"; _pass="passwd"; _keep_team_id = nil
user01=User.create!(name: _name, email: _email, password: _pass)
_name = "test02"; _email= "test02@example.com"; _pass="passwd"; _keep_team_id = nil
user02=User.create!(name: _name, email: _email, password: _pass)
_name = "test03"; _email= "test03@example.com"; _pass="passwd"; _keep_team_id = nil
user03=User.create!(name: _name, email: _email, password: _pass)

_name = "DefaultTeam"
team00=Team.create!(name: _name, owner_id: sys_user.id)
_name = "Team01"
team01=Team.create!(name: _name, owner_id: user01.id)
_name = "Team02"
team02=Team.create!(name: _name, owner_id: user02.id)

Assign.create!(user_id: sys_user.id, team_id: team00.id)
Assign.create!(user_id: user01.id, team_id: team00.id)
Assign.create!(user_id: user02.id, team_id: team00.id)
