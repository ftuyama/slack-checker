class Slack
  SLACK_TOKEN = ENV['SLACK_TOKEN']

  def self.get_users
    HTTParty.get("https://slack.com/api/users.list", headers: headers())
  end

  def self.send_message(text)
    params = "?channel=yomi&text=#{CGI::escape(text)}"
    HTTParty.get("https://slack.com/api/chat.postMessage#{params}", headers: headers('text/plain; charset=utf-8'))
  end

  private

  def self.headers(content_type = 'application/json')
    headers = {
      'Content-Type' => content_type,
      'Accept' => 'application/json',
      'Authorization' => "Bearer #{SLACK_TOKEN}",
    }
  end
end
