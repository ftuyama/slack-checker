require 'httparty'

class Slack
  EARS_CHANNEL = ENV['EARS_CHANNEL']
  SLACK_CHANNEL = ENV['SLACK_CHANNEL'] || 'yomi'
  SLACK_TOKEN = ENV['SLACK_TOKEN']

  def self.get_users
    HTTParty.get("https://slack.com/api/users.list", headers: headers())
  end

  def self.get_messages
    params = {
      channel: EARS_CHANNEL,
      limit: 50
    }

    HTTParty.get("https://slack.com/api/conversations.history", query: params, headers: headers())
  end

  def self.send_message(text)
    return unless SLACK_TOKEN

    params = {
      channel: SLACK_CHANNEL,
      text: text
    }

    HTTParty.get("https://slack.com/api/chat.postMessage", query: params, headers: headers('text/plain; charset=utf-8'))
  end

  def self.send_image(image_url, label: "", actions: [])
    return unless SLACK_TOKEN

    attachments = [{
      "fallback": ":skull:",
      "text": ":skull: #{label}",
      "image_url": image_url,
      "thumb_url": image_url,
      "actions": actions,
    }]

    params = {
      channel: SLACK_CHANNEL,
      attachments: attachments.to_json
    }

    HTTParty.get("https://slack.com/api/chat.postMessage", query: params, headers: headers('text/plain; charset=utf-8'))
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
