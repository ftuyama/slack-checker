class FuneralCall
  SLACK_ACTIVE = ENV['SLACK_ACTIVE']

  def self.send_message(message)
    Slack.send_message(message) if SLACK_ACTIVE

    puts message
  end

  def self.print_skull
    Slack.send_message(":skull:") if SLACK_ACTIVE

    File.open('death', 'r').readlines.each { |l| puts l }
  end
end
