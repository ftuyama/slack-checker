require 'pry-rails'
load 'model/member.rb'
load 'util/db.rb'
load 'util/funeral_call.rb'
load 'util/slack_cache.rb'

members = SlackCache.fetch(:users).map { |data| Member.new(data) }
period = (Time.now - 86400*(ARGV&.first || 7).to_i).to_i

news = members.map do |member|
  next if member.updated < period

  picture_time = member.picture_time
  next if !picture_time.nil? && picture_time < period

  birth_time = member.birth_time
  next if !birth_time.nil? && birth_time < period

  member.profile_linked_label
end.compact!.sort!

if !news.empty?
  FuneralCall.send_message("\n\t\tNOVINHOS!! :querido:\n")
  FuneralCall.send_message(news.join("\n"))
end
