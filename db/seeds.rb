users = ["Manny","Anik"]
users.each do |user|
  User.create(name: user)
end

# user1 = User.first
# user2 = User.last
#
# user1.save
# user2.save
#
# match1 = Match.create(user_id: user1, buddy_id: user2)
# match1.save

puts "Done~!"
