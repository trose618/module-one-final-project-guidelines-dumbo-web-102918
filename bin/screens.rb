programming_topics = ["Ruby Fundamentals", "Object Oriented Ruby", "SQL", "ORMs/ActiveRecord"]

def welcome
  "Welcome to Study Buddy!!! 🤓"
end

def get_name
  puts " "
  prompt = TTY::Prompt.new
  prompt.ask('What is your name?')
end

def user_exist?(name)
  exist = User.find_by(name: name)
  !!exist
end

def update_info(name)
  system "clear"
  puts " "
  prompt = TTY::Prompt.new
  command = prompt.select("What do you want to update?", ["Strength 💪🏼", "Weakness 😫", "Go Back"])

  case command
  when "Strength 💪🏼"
    update_strength(name)
  when "Weakness 😫"
    update_weakness(name)
  when "Go Back"
    menu_screen(name)
  end
end

def menu_screen(name)
  display_skills(name) if user_exist?(name)
  puts " "
  prompt = TTY::Prompt.new
  command = prompt.select("What would you like to do?", ["Update Skills", "Display Matches", "Quit"])
  case command
  when "Update Skills"
    update_info(name)
  when "Display Matches"
    display_buddies(name)
  when "Quit"
    puts "Session Ended"
    exit
  end
end

def get_user_skills(name)
  user_skill_array = UserSkill.all.select { |userskill|
    userskill.user_id == User.find_by(name: name).id
  }
end

def display_skills(name)
  puts " "
  #UserSkill.all.select
  puts "Your Strengths: 💪🏼"

  strength_array = get_user_skills(name).map { |us| Skill.find_by(id: us.skill_id).name}

    strength_array.each { |str|
      puts str
    }

  puts " "
  puts "Your Weakness: 😫"
  puts "#{User.find_by(name: name).weakness}"
end

def destroy_str_associations(name)
  UserSkill.where(user_id: User.find_by(name: name)).destroy_all
end

def update_strength(name)
  system "clear"
  puts " "
  prompt = TTY::Prompt.new
  skills = Skill.all.map { |skill| skill.name}
  choices = prompt.multi_select("What skills are you comfortable with now?", skills)
  destroy_str_associations(name)
  choices.each do |choice|
    UserSkill.create(user_id: User.find_by(name: name).id, skill_id: Skill.find_by(name: choice).id)
  end
  menu_screen(name)
end

def update_weakness(name)
  #display_skills(name)
  system "clear"
  puts " "
  prompt = TTY::Prompt.new
  skills = Skill.all.map { |skill| skill.name}
  command = prompt.select("What are you least comfortable with?", skills)
  User.find_by(name: name).update(weakness: command)
  menu_screen(name)

  destroy_matches(name)
  create_matches(name)
end

def destroy_matches(name)
  Match.where(user_id: User.find_by(name: name).id).destroy_all
end

def display_buddies(name)
  system "clear"
  if helpers(name).empty?
    puts "Sorry, no matches were found."
  else
    puts "Your recommended study buddies are:"
    helpers(name).each { |helper| puts helper.name.capitalize unless helper.name == name}
  end
  menu_screen(name)
end

def helpers(name)
  wkn = Skill.find_by(name: User.find_by(name: name).weakness)
  str_users = UserSkill.where(skill_id: wkn.id)
  str_users.map {|str_user| User.find_by(id: str_user.user_id)}
end

def create_matches(name)
  helpers(name).each do |user|
    !if Match.all.include?(Match.new(user_id: User.find_by(name: name).id, buddy_id: user.id))
    binding.pry
      Match.create(user_id: User.find_by(name: name).id, buddy_id: user.id) unless user.id == User.find_by(name: name).id
    end
  end
end


def new_user(name)
  puts " "
  prompt = TTY::Prompt.new
  skills = Skill.all.map { |skill| skill.name}
  choices = prompt.multi_select("What skills are you comfortable with now?", skills)
  prompt2 = TTY::Prompt.new
  wkn = prompt2.select("What skill are you least comfortable with?", ["Ruby Fundamentals", "API/JSON", "Object Oriented Ruby", "SQL", "ORMs/ActiveRecord"])
  User.create(name: name, weakness: wkn)
  choices.each do |choice|
    UserSkill.create(user_id: User.find_by(name: name).id, skill_id: Skill.find_by(name: choice).id)
  end

end
