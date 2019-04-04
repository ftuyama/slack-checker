require 'httparty'
require 'pry-rails'
load 'util/db.rb'
load 'util/funeral_call.rb'
load 'util/slack.rb'

response = Slack.get_users()

last_alive = DB.load()

members_data = response["members"].map do |m|
  {
    name: m["name"] || m["profile"]["real_name"] || m["real_name"],
    picture: m["profile"]["image_72"],
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
  FuneralCall.send_message("ALMOST!! No one is dead!", probability: 10)
else
  FuneralCall.print_skull()
  FuneralCall.send_message("\n\n\n\t\tOMG!\n\n\n")
  dead.each do |d|
    dead_data = members_data.find { |u| u[:name] == d }
    death_time = Time.at(dead_data[:updated]).strftime("%F %T")

    FuneralCall.send_death_message("#{death_time} #{d} IS DEAD!!!!", dead_data)
  end
end

DB.save(alive)
