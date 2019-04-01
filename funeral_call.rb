class FuneralCall
  SLACK_ACTIVE = ENV['SLACK_ACTIVE']
  SKULL_ART = File.open('death', 'r').readlines

  def self.send_message(message)
    Slack.send_message(message) if SLACK_ACTIVE
    puts message
  end

  def self.print_skull
    huge_skull = "```" + SKULL_ART.join() + "```"

    Slack.send_message(huge_skull) if SLACK_ACTIVE
    puts huge_skull
  end
end
