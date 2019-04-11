require 'httparty'
require 'pry-rails'
load 'model/member.rb'
load 'util/db.rb'
load 'util/funeral_call.rb'
load 'util/slack.rb'

@db = DB.new

last_alive = @db.load()

members = Slack.get_users()["members"].map { |data| Member.new(data) }

last_month = (Time.now - 86500*30).to_i

month_deaths = members.map do |member|
  if member.deleted && member.updated > last_month
    member.profile
  end
end.compact!.sort!

FuneralCall.print_art(:grave)
FuneralCall.send_message("\n\n\t:skull: Members who died last month :skull:\n\n")
FuneralCall.send_message(month_deaths.join("\n"))
