require_relative '../config/environment'
require_relative './screens'
require 'pry'
require 'tts'

welcome

name = get_name.downcase

if user_exist?(name)
  menu_screen(name)
else
  new_user(name)
  menu_screen(name)
end
