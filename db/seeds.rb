# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.find_or_initialize_by(uid: 'admin', email: 'admin@example.com') do |user|
  user.password = 'password'
  user.save!
  user.add_role(:admin)
end
User.find_or_initialize_by(uid: 'user01', email: 'user01@example.com') do |user|
  user.password = 'password'
  user.save!
end
User.find_or_initialize_by(uid: 'user02', email: 'user02@example.com') do |user|
  user.password = 'password'
  user.save!
end
