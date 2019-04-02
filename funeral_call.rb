class FuneralCall
  SKULL_ART = "```" + File.open('death', 'r').readlines.join() + "```"

  def self.send_message(message)
    Slack.send_message(message)

    puts message
  end

  def self.send_death_message(message, data)
    Slack.send_image(data[:picture], data[:name])
    Slack.send_message(message)

    puts message
  end

  def self.print_skull
    Slack.send_message(SKULL_ART)

    puts SKULL_ART
  end
end
