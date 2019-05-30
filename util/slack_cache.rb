load 'util/slack.rb'

class SlackCache
  CACHE_TIME = 10 * 60

  def self.fetch_with_params(content, id)
    @db = DB.new(DB::FILES[content] + "#{id}.json")

    if @db.older_than(CACHE_TIME)
      @db.save_json(request_slack_with_params(content, id))
    else
      @db.load_json
    end
  end

  def self.fetch(content)
    @db = DB.new(DB::FILES[content])

    if @db.older_than(CACHE_TIME)
      @db.save_json(request_slack(content))
    else
      @db.load_json
    end
  end

  def self.request_slack_with_params(content, id)
    case content
    when :profile
      Slack.get_profile(id)["profile"]
    end
  end

  def self.request_slack(content)
    case content
    when :messages
      Slack.get_messages["messages"]
    when :users
      Slack.get_users["members"]
    when :channels
      Slack.get_channels["groups"]
    end
  end
end
