require 'pry-rails'
load 'model/member.rb'
load 'util/db.rb'
load 'util/funeral_call.rb'
load 'util/slack_cache.rb'

@db = DB.new

last_alive = @db.load()

members = SlackCache.fetch(:users).map { |data| Member.new(data) }

alive = members.map do |member|
  unless member.deleted
    member.name
  end
end.compact!.sort!

dead = last_alive - alive

if dead.empty?
  FuneralCall.send_message("ALMOST!! No one is dead!", probability: 10)
else
  FuneralCall.print_art(:skull)
  FuneralCall.send_message("\n\n\n\t\tOMG!\n\n\n")
  dead.each do |dead_name|
    dead_member = members.find { |member| member.name == dead_name }

    FuneralCall.send_death_message(dead_name, dead_member.picture, dead_member.profile)
  end
end

@db.save(alive)
