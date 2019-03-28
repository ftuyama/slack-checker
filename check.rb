require 'httparty'
require 'pry-rails'
load 'slack.rb'

response = Slack.get_users()

last_alive = File.open('alive.txt').readlines.map(&:strip)

members_data = response["members"].map do |m|
  {
    name: m["name"] || m["profile"]["real_name"] || m["real_name"],
    deleted: m["deleted"],
    updated: m["updated"]
  }
end

alive = members_data.map do |m|
  unless m[:deleted]
    m[:name]
  end
end.compact!.sort!

dead = last_alive - alive

if dead.empty?
  puts "ALMOST!!"
else
  puts "OMG!"
  dead.each do |d|
    dead_data = members_data.find { |u| u[:name] == d }
    death_time = Time.at(dead_data[:updated]).strftime("%F %T")

    puts "#{death_time} #{d} IS DEAD!!!!"
  end
end

File.open("alive.txt", "w+") { |f| f.puts(alive) }
