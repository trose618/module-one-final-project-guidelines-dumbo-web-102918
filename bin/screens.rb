def welcome
  puts " "
  puts "Welcome to Study Buddy!!! 🤓"
  "Welcome to Study Buddy!".play
end

def get_name
  puts " "
  prompt = TTY::Prompt.new
  name = prompt.ask("What is your first name?", "What is your first name?".play)
  "Hi #{name}!".play
  name
end

def user_exist?(name)
  exist = User.find_by(name: name)
  !!exist
end

def update_info(name)
  system "clear"
  puts " "
  puts "What do you want to update? You can change your strengths, weakness, or go back."
  "What do you want to update?".play
  prompt = TTY::Prompt.new

  command = prompt.select(" ", ["Strength 💪🏼", "Weakness 😫", "Go Back"])

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
  puts "What would you like to do? You can update your skills, display study matches, or quit."
  "What would you like to do?".play
  prompt = TTY::Prompt.new
  command = prompt.select(" ", ["Update Skills", "Display Matches", "Quit"])
  case command
  when "Update Skills"
    update_info(name)
  when "Display Matches"
    display_buddies(name)
  when "Quit"
    puts "Session Ended"
    "Ending session".play
    exit
  end
end

def get_user_skills(name)
  user_skill_array = UserSkill.all.select { |userskill|
    userskill.user_id == User.find_by(name: name).id
  }.map { |us| Skill.find_by(id: us.skill_id).name}
end

def display_skills(name)
  puts " "
  #UserSkill.all.select
  puts "Your Strengths: 💪🏼"

  get_user_skills(name).each { |str|
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
  puts "What skills are you comfortable with now? You can choose more than one. (Use arrow keys, press Space to select and Enter to finish)"
  "What skills are you comfortable with now?".play
  prompt = TTY::Prompt.new
  skills = Skill.all.map { |skill| skill.name}
  choices = prompt.multi_select(" ", skills)
  if choices.empty?
    puts "Please select your skill(s), or would you like to return to the main menu?"
    "Please select your skills, or would you like to return to the main menu?".play
    prompt = TTY::Prompt.new
    command = prompt.select(" ", ["Update Strength", "Main Menu"])
    if command == "Update Strength"
      update_strength(name)
    else
      menu_screen(name)
    end
  else
    destroy_str_associations(name)
    choices.each do |choice|
      UserSkill.create(user_id: User.find_by(name: name).id, skill_id: Skill.find_by(name: choice).id)
    end
  end
  menu_screen(name)
end

def update_weakness(name)
  #display_skills(name)
  system "clear"
  puts " "
  puts "What skill are you least comfortable with?"
  "What skill are you least comfortable with?".play
  prompt = TTY::Prompt.new
  skills = Skill.all.map { |skill| skill.name}
  command = prompt.select(" ", skills << "Go Back")
  if get_user_skills(name).include?(command)
   puts "You already have this skill listed as a strength."
   "You already have this skill listed as a strength.".play
   update_weakness(name)
 elsif command == "Go Back"
     update_info(name)
   else
   User.find_by(name: name).update(weakness: command)
 end
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
    "Sorry, no matches were found.".play
  else
    study_buddies = []
    puts "Your recommended study buddies for #{User.find_by(name: name).weakness} are: 🤓"
    helpers(name).each do |helper|
      puts helper.name.capitalize unless helper.name == name
      study_buddies << helper.name.capitalize unless helper.name == name
    end
    "Your recommended study buddies for #{User.find_by(name: name).weakness} are #{study_buddies}".play
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
