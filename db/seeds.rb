Skill.destroy_all
ActiveRecord::Base.connection.execute("Delete from skills")
ActiveRecord::Base.connection.execute("DELETE FROM SQLITE_SEQUENCE WHERE name='skills'")

User.destroy_all # Only necessary if you want to trigger callbacks.
ActiveRecord::Base.connection.execute("Delete from users")
ActiveRecord::Base.connection.execute("DELETE FROM SQLITE_SEQUENCE WHERE name='users'")

Match.destroy_all # Only necessary if you want to trigger callbacks.
ActiveRecord::Base.connection.execute("Delete from matches")
ActiveRecord::Base.connection.execute("DELETE FROM SQLITE_SEQUENCE WHERE name='matches'")

UserSkill.destroy_all
ActiveRecord::Base.connection.execute("Delete from user_skills")
ActiveRecord::Base.connection.execute("DELETE FROM SQLITE_SEQUENCE WHERE name='user_skills'")

Skill.create(name: "Ruby Fundamentals")
Skill.create(name: "API/JSON")
Skill.create(name: "Object Oriented Ruby")
Skill.create(name: "SQL")
Skill.create(name: "ActiveRecord")
puts "Done~!"
