require 'httparty'
require 'pry-rails'
load 'model/member.rb'
load 'util/db.rb'
load 'util/funeral_call.rb'
load 'util/slack_cache.rb'

@db = DB.new

last_alive = @db.load()

members = SlackCache.fetch(:users).map { |data| Member.new(data) }

last_month = (Time.now - 86400*30).to_i

month_births = []
month_deaths = []

members.each do |member|
  next if member.updated < last_month

  if member.deleted
    month_deaths << member.profile_label
  else
    picture_time = member.picture_time
    next if picture_time.nil? || picture_time < last_month

    birth_time = member.birth_time
    next if birth_time.nil? || birth_time < last_month

    month_births << member.profile_label
  end
end

binding.pry
FuneralCall.print_art(:grave)
FuneralCall.send_message("\n\n\t[HEADCOUNT] ( *+#{month_births.count}* | *#{month_deaths.count}* )\n\n")
FuneralCall.send_message("\n\n\t:skull: Members who died last month :skull:\n\n")
FuneralCall.send_message(month_deaths.join("\n"))
FuneralCall.send_message("\n\n\t:skull: Members who were born last month :skull:\n\n")
FuneralCall.send_message(month_births.join("\n"))
