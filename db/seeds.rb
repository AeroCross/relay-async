# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'date'
def random_date(start: Date.new(2014, 01, 01).to_time.to_i, finish: Time.now.to_i)
  date = (start..finish)
  Time.at(rand(date))
end

# amount of records
users = (1..10)
tickets = (1..50)
messages = (1..150)
id = Random.new

# fill out users
users.each do
  u = User.new
  u.fullname = Faker::Name.name
  u.username = Faker::Internet.user_name
  u.email = Faker::Internet.email
  u.password = Faker::Internet.password
  u.save
  u.created_at = random_date
  u.save
end

# fill out tickets
tickets.each do
  t = Ticket.new
  t.user_id = id.rand(users)
  t.subject = Faker::Lorem.sentence(4, true, 6)
  t.content = Faker::Lorem.paragraph(4, true, 6)
  t.save
  t.created_at = random_date
  t.save
end

# fill out messages
source = %w'chat ticket'
messages.each do
  m = Message.new
  m.user_id = id.rand(users)
  m.ticket_id = id.rand(tickets)
  m.content = Faker::Lorem.sentence(2)
  m.source = source[id.rand((0..1))]
  m.save
  m.created_at = random_date
  m.save
end