require_relative '../config/environment'
require 'pry'

users = [" ", " "]

users.each do |user|
  puts "Enter your name."
  nam = gets
  puts "Enter your strength"
  str = gets
  puts "Enter your weakness"
  wkn = gets
  User.create(name: nam, strength: str, weakness: wkn)
  
end

binding.pry

puts "HELLO WORLD"
