require 'httparty'
require 'pry-rails'

slack_token = ENV['SLACK_TOKEN']

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  'Authorization' => "Bearer #{slack_token}",
}

response = HTTParty.get("https://slack.com/api/users.list", headers: headers)

last_alive = File.open('alive.txt').readlines.map(&:strip)

alive = response["members"].map do |m|
  member = m["name"] || m["profile"]["real_name"] || m["real_name"]

  member unless m["deleted"]
end.compact!.sort!

dead = last_alive - alive

if dead.empty?
  puts "ALMOST!!"
else
  puts "OMG!"
  dead.each { |d| puts "#{d} IS DEAD!!!!" }
end

File.open("alive.txt", "w+") { |f| f.puts(alive) }
