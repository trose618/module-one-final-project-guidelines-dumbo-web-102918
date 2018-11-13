def welcome
  "Welcome to Study Buddy!!!"
end

def get_name
  puts "What is your name?"
  gets.chomp
end

def user_exist?(name)
  exist = User.find_by(name: name)
  exist ? true : false
end

def update_info(name)

  puts "What do you want to update?"
  puts "1. Strength"
  puts "2. Weakness"
  puts "3. Go Back"

  command = gets.chomp

  case command
  when "1"
    puts "update strength"
  when "2"
    puts "update weakness"
  when "3"
    menu_screen(name)
  else
    puts "Invalid input. Please select 1, 2 or 3."
    update_info(name)
  end
  menu_screen(name)
end

def menu_screen(name)
  puts "What would you like to do?"
  puts "1. Update info"
  puts "2. Display matches"
  puts "3. Quit"

  cmd = gets.chomp

  case cmd
  when "1"
    update_info(name)
  when "2"
    puts "display_matches"
    #display_matches(name)
  when "3"
    puts "Quit"
  else
    puts "Invalid input. Please select 1, 2 or 3."
    menu_screen(name)
  end
  menu_screen(name)
end

def display_attributes(name)
  puts "Strength: #{User.find_by(name: name).strength}"
  puts "Weakness: #{User.find_by(name: name).weakness}"
  puts " "
end

def display_matches
  #"your recommended study buddies are: listed"
end
