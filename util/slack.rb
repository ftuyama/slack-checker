require 'httparty'

class Slack
  EARS_CHANNEL = ENV['EARS_CHANNEL']
  SLACK_CHANNEL = ENV['SLACK_CHANNEL']
  SLACK_TOKEN = ENV['SLACK_TOKEN']
  SUPER_SLACK_TOKEN = ENV['SUPER_SLACK_TOKEN']

  def self.get_groups
    HTTParty.get("https://slack.com/api/groups.list", headers: headers())
  end

  def self.get_channels
    HTTParty.get("https://slack.com/api/channels.list", headers: headers())
  end

  def self.channel_id(channel)
    groups = SlackCache.fetch(:groups)
    group = groups.find { |c| c["name"] == channel }
    return group["id"] if group

    channels = SlackCache.fetch(:channels)
    channel = channels.find { |c| c["name"] == channel }
    return channel["id"] if channel
  end

  def self.get_users
    HTTParty.get("https://slack.com/api/users.list", headers: headers())
  end

  def self.delete_message(message_timestamp)
    return if slack_not_configured || message_timestamp.nil?

    params = {
      channel: channel_id(SLACK_CHANNEL),
      ts: message_timestamp
    }.to_json

    HTTParty.post("https://slack.com/api/chat.delete", body: params, headers: headers('application/json; charset=utf-8'))
  end

  def self.get_messages(channel: nil)
    params = {
      channel: channel.nil? ? channel_id(EARS_CHANNEL) : (SLACK_CHANNEL),
      limit: 50
    }

    HTTParty.get("https://slack.com/api/conversations.history", query: params, headers: headers())
  end

  def self.get_replies(channel: nil, reply: nil)
    return if reply.nil?

    params = {
      channel: channel.nil? ? EARS_CHANNEL : SLACK_CHANNEL,
      thread_ts: reply
    }

    HTTParty.get("https://slack.com/api/groups.replies", query: params, headers: headers(token: SUPER_SLACK_TOKEN))
  end

  def self.get_profile(user_id)
    params = {
      user: user_id
    }

    HTTParty.get("https://slack.com/api/users.profile.get", query: params, headers: headers(token: SUPER_SLACK_TOKEN))
  end


  def self.send_message(text)
    return if slack_not_configured

    params = {
      channel: SLACK_CHANNEL,
      text: text
    }.merge!(self.bot_identity)

    HTTParty.get("https://slack.com/api/chat.postMessage", query: params, headers: headers('text/plain; charset=utf-8'))
  end

  def self.react(message_timestamp, reaction)
    return if slack_not_configured

    params = {
      channel: channel_id(SLACK_CHANNEL),
      name: reaction,
      timestamp: message_timestamp
    }.to_json

    HTTParty.post("https://slack.com/api/reactions.add", body: params, headers: headers('application/json; charset=utf-8'))
  end

  def self.send_image(image_url, label: "", reply: nil, actions: [])
    return if slack_not_configured

    reply = reply.nil? ? {} : {thread_ts: reply}

    attachments = [{
      "fallback": ":skull:",
      "text": ":skull: #{label}",
      "image_url": image_url,
      "thumb_url": image_url,
      "actions": actions
    }]

    params = {
      channel: SLACK_CHANNEL,
      attachments: attachments.to_json
    }.merge!(self.bot_identity).merge!(reply)

    HTTParty.get("https://slack.com/api/chat.postMessage", query: params, headers: headers('text/plain; charset=utf-8'))
  end

  private

  def self.slack_not_configured
    SLACK_TOKEN.nil? || SLACK_CHANNEL.nil?
  end

  def self.bot_identity
    {
      as_user: false,
      username: "death",
      icon_url: "https://image.flaticon.com/icons/png/512/12/12231.png",
    }
  end

  def self.headers(content_type = 'application/json', token: SLACK_TOKEN)
    headers = {
      'Content-Type' => content_type,
      'Accept' => 'application/json',
      'Authorization' => "Bearer #{token}",
    }
  end
end
