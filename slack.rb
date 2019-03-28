class Slack
  SLACK_TOKEN = ENV['SLACK_TOKEN']

  def self.get_users
    headers = {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json',
      'Authorization' => "Bearer #{SLACK_TOKEN}",
    }

    HTTParty.get("https://slack.com/api/users.list", headers: headers)
  end
end
