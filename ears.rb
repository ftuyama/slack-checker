require 'colorize'
require 'pry-rails'
load 'util/db.rb'
load 'util/slack_cache.rb'

messages = SlackCache.fetch(:messages)
users = SlackCache.fetch(:users)

messages.reverse!.each do |message|
  time = Time.at(message["ts"].split(".").first.to_i).strftime("%F %T")
  user = users.find { |u| u["id"] == message["user"] }
  text = message["text"]

  text.dup.scan(/<@(\w{9})>/) do |matches|
    matches.each do |match|
      user = users.find { |u| u["id"] == match }
      text.gsub!("@#{match}", "@#{user["name"]}".cyan)
    end
  end
  text.gsub!("!here", "@here".cyan)
  text.gsub!("!channel", "@channel".cyan)

  # thread = Slack.get_replies(reply: message["ts"])

  begin
    puts [time.yellow, user["name"].red, text].join(" ")
  rescue
    puts "..."
  end
end

