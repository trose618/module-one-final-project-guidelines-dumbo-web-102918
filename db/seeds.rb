
User.create(name: "Rob", strength: "oo", weakness: "ActiveRecord")
User.create(name: "Terrance", strength: "ActiveRecord", weakness: "chicken")

Match.create(user: User.first, buddy: User.last)

# user1 = User.first
# user2 = User.last
#
# user1.save
# user2.save
#
# match1 = Match.create(user_id: user1, buddy_id: user2)
# match1.save

puts "Done~!"
