def welcome
  puts " "
  puts "Welcome to Study Buddy!!! 🤓"
  "Welcome to Study Buddy!".play
end

def get_name
  puts " "
  name = nil
  prompt = TTY::Prompt.new
  name = prompt.ask("What is your first name?", "What is your first name?".play)
  while name == nil || name.length > 15 || name.scan(/[`1234567890!@#$%^&*()_+{}\[\]:;'"\/\\?><.,]/).any?
    prompt = TTY::Prompt.new
    name = prompt.ask("That's cool, but what is your first name?", "That's cool, but what is your first name?".play)
  end
  "Hi #{name}!".play
  name.downcase
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
  command = prompt.select(" ", ["Update Skills", "Recommend Study Buddies", "Quit"])
  case command
  when "Update Skills"
    update_info(name)
  when "Recommend Study Buddies"
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
  puts "Press SPACEBAR to select the skill(s) you are most comfortable with."
  puts "You can choose more than one, press ENTER when done."
  puts "To go back to the main menu, press ENTER without selecting any choices."
  "Press SPACEBAR to select the skill(s) you are most comfortable with.".play
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
    User.find_by(name: name).update(weakness: "None") if Skill.all.size == choices.size
    destroy_str_associations(name)
    choices.each do |choice|
      UserSkill.create(user_id: User.find_by(name: name).id, skill_id: Skill.find_by(name: choice).id)
    end
  end
  puts "Would you like to update your weakness (#{User.find_by(name: name).weakness})?"
  "Would you like to update your weakness (#{User.find_by(name: name).weakness})?".play
  prompt2 = TTY::Prompt.new
  command2 = prompt.select(" ", ["Yes", "No"])
  if command2 == "Yes"
    update_weakness(name)
  else command2 == "No"
    if choices.include?(User.find_by(name: name).weakness)
      puts "You have #{User.find_by(name: name).weakness} listed as both a strength and a weakness. Please update your weakness."
      "You have #{User.find_by(name: name).weakness} listed as both a strength and a weakness. Please update your weakness.".play
      update_weakness(name)
    else
    menu_screen(name)
    end
  end
end

def update_weakness(name)
  system "clear"
  puts " "
  puts "What skill are you least comfortable with (currently #{User.find_by(name: name).weakness})?"
  "What skill are you least comfortable with (currently #{User.find_by(name: name).weakness})?".play
  prompt = TTY::Prompt.new
  skills = Skill.all.map { |skill| skill.name}
  command = prompt.select(" ", skills << "None"<< "Go Back")
  if get_user_skills(name).include?(command) and command != "None"
    puts "You also have #{command} listed as a strength."
    puts "Would you like to update your strengths?"
    "You also have #{command} listed as a strength. Would you like to update your strengths?".play
    prompt2 = TTY::Prompt.new
    prompt2 = prompt2.select(" ", ["Yes", "No"])
    prompt2 == "Yes" ? update_strength(name) : update_weakness(name)
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
  if User.find_by(name: name).weakness == "None"
    thumbsup
    puts "Sorry, no matches were found because you are a coding god (You selected 'None' as your weakness)."
    "Sorry, no matches were found because you are a coding god.".play
  elsif helpers(name).empty?
    sad_face
    puts "Sorry, we found no one who is strong with #{User.find_by(name: name).weakness} from your mod or there is not enough data at this time (#{User.all.size} users)."
    "Sorry, we found no one who is strong with #{User.find_by(name: name).weakness} from your mod or there is not enough data at this time (#{User.all.size} users).".play
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
  return [] if wkn == nil
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
  newbie = User.create(name: name, weakness: "None")
  new = UserSkill.create(user_id: newbie.id, skill_id: 1)
  puts " "
  puts "Press SPACEBAR to select the skill(s) you are most comfortable with."
  puts "You can choose more than one, press ENTER when done."
  "Press SPACEBAR to select the skills you are most comfortable with.".play
  prompt = TTY::Prompt.new
  skills = Skill.all.map { |skill| skill.name}
  choices = prompt.multi_select(" ", skills)
  if choices.empty?
    puts "Please select at least one skill."
    "Please select at least one skill".play
    update_strength(name)
  elsif Skill.all.size == choices.size
    User.create(name: name, weakness: "None")
    choices.each do |choice|
      UserSkill.create(user_id: User.find_by(name: name).id, skill_id: Skill.find_by(name: choice).id)
    end
  else
    User.create(name: name, weakness: "None")
    choices.each do |choice|
      UserSkill.create(user_id: User.find_by(name: name).id, skill_id: Skill.find_by(name: choice).id)
    end
    wkn = create_weakness(name)
    while choices.include?(wkn)
      puts "You also have #{wkn} listed as a strength. Would you like to update your strengths?"
      "You also have #{wkn} listed as a strength. Would you like to update your strengths?".play
      prompt2 = TTY::Prompt.new
      prompt2 = prompt2.select(" ", ["Yes", "No"])
      prompt2 == "Yes" ? update_strength(name) : wkn = create_weakness(name)
    end
    User.find_by(name: name).update(weakness: wkn)
  end
end

def create_weakness(name)
  prompt = TTY::Prompt.new
  puts "What skill are you least comfortable with?"
  "What skill are you least comfortable with?".play
  skills = Skill.all.map { |skill| skill.name}
  command = prompt.select(" ", skills << "None")
end
