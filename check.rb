require 'pry-rails'
load 'model/member.rb'
load 'util/db.rb'
load 'util/funeral_call.rb'
load 'util/slack_cache.rb'

@db = DB.new

last_alive = @db.safe_load()

members = SlackCache.fetch(:users).map { |data| Member.new(data) }

alive = members.map do |member|
  unless member.deleted
    member.name
  end
end.compact!.sort!

dead = last_alive - alive

if dead.empty?
  FuneralCall.send_message("ALMOST!! No one is gone!", probability: 10)
else
  FuneralCall.print_art(:skull, probability: 10)
  FuneralCall.send_message("\n\n\n\t\tOMG!\n\n\n")
  dead.each do |dead_name|
    dead_member = members.find { |member| member.name == dead_name }
    if dead_member
      FuneralCall.send_death_message(dead_name, dead_member.picture, dead_member.profile_label)
    else
      FuneralCall.send_message("\n\n\n\t\t#{dead_name} is gone!\n\n\n")
    end
  end
end

@db.save(alive)
