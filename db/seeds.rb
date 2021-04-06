# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

_name = "system"; _email= "system@example.com"; _pass="passwd"; _keep_team_id = 1
sys_user=User.create!(name: _name, email: _email, password: _pass, keep_team_id:  _keep_team_id)

_name = "test01"; _email= "test01@example.com"; _pass="passwd"; _keep_team_id = 1
user01=User.create!(name: _name, email: _email, password: _pass, keep_team_id:  _keep_team_id)

_name = "test02"; _email= "test02@example.com"; _pass="passwd"; _keep_team_id = 1
user02=User.create!(name: _name, email: _email, password: _pass, keep_team_id:  _keep_team_id)

_name = "test03"; _email= "test03@example.com"; _pass="passwd"; _keep_team_id = 1
user03=User.create!(name: _name, email: _email, password: _pass, keep_team_id:  _keep_team_id)

_name = "DefaultTeam"
team00=Team.create!(name: _name, owner_id: sys_user.id)
