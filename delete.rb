require 'pry-rails'
load 'model/member.rb'
load 'util/db.rb'
load 'util/funeral_call.rb'
load 'util/slack_cache.rb'

response = Slack.get_messages()
messages = response["messages"]
bot_messages = messages.select { |m| !m["bot_id"].nil? }

binding.pry
# Slack.delete_message()
