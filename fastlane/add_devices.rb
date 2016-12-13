#!/usr/bin/env ruby

require 'spaceship'

Spaceship.login(ENV['APPLE_USERNAME'], ENV['APPLE_PASSWORD'])
Spaceship.select_team()

puts "Found #{Spaceship.device.all.count} devices! 🚀"

names = ARGV[0].split(",")
udids = ARGV[1].split(",")

names.each_with_index do |name, index|
  udid = udids[index]
  puts "Adding device: #{name}"
  Spaceship.device.create!(name: name, udid: udid)
end

puts "New device added!"
puts "Now at #{Spaceship.device.all.count} devices"
