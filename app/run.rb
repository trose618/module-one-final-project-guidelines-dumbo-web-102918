require_relative '../config/environment'
require 'pry'

users = [" ", " "]

users.each do |user|
  puts "Enter your name."
  nam = gets.chomp
  puts "Enter your strength"
  str = gets.chomp
  puts "Enter your weakness"
  wkn = gets.chomp
  User.create(name: nam, strength: str, weakness: wkn)

end

binding.pry

puts "HELLO WORLD"
