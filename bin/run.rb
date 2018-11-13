require_relative '../config/environment'
require_relative './screens'
require 'pry'

#welcome user
puts welcome
#get user name
name = get_name
#check if user exists
#if user exists
if user_exist?(name)
  #ask user to enter one of the 3 commands
  display_attributes(name)
  menu_screen(name)
else
#else update info
  #prompt user for input
  puts "You have not set your strengths and weaknesses yet. Please set them below."
  puts " "
  update_info(name)
end
