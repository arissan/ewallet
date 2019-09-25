# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
7.times do |t|
  email_stock= "stock-#{t}@stock.com"
  email_team= "team-#{t}@team.com"
  Stock.create(email: email_stock, password: email_stock, password_confirmation: email_stock)
  Team.create(email: email_team, password: email_team, password_confirmation: email_team)
end

p User.all.map(&:email)

User.all.each do |u|
  p "Deposit: #{u.email}"
  u.deposit(10000)

  p "Withdraw: #{u.email}"
  u.withdraw(rand(100))

  ids= User.all.map(&:id)
  rand_id= ids[rand(User.count-1)]

  target= User.find(rand_id)
  p "Transfer: from #{u.email}, to #{target.email}"
  u.transfer(target, rand(100))
end