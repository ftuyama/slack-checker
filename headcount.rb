require 'httparty'
require 'pry-rails'
load 'model/member.rb'
load 'util/db.rb'
load 'util/funeral_call.rb'
load 'util/slack_cache.rb'

@db = DB.new

last_alive = @db.load()

members = SlackCache.fetch(:users).map { |data| Member.new(data) }

last_month = (Time.now - 86500*30).to_i

month_births = []
month_deaths = []

members.each do |member|
  if member.updated > last_month
    if member.deleted
      month_deaths << member.profile_label
    else
      birth_time = member.birth_time
      if birth_time && birth_time > last_month
        month_births << member.profile_label
      end
    end
  end
end

binding.pry
# FuneralCall.print_art(:grave)
# FuneralCall.send_message("\n\n\t:skull: Members who died last month :skull:\n\n")
# FuneralCall.send_message(month_deaths.join("\n"))
