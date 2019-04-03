class FuneralCall

  def self.send_message(message)
    Slack.send_message(message)

    puts message
  end

  def self.send_death_message(message, data)
    Slack.send_image(data[:picture], label: data[:name], actions: funeral_actions())
    Slack.send_message(message)

    puts message
  end

  def self.print_skull
    Slack.send_message(skull_art())

    puts skull_art()
  end

  def self.skull_art
    "```" + File.open("ascii/death#{rand(3)}", 'r').readlines.join() + "```"
  end

  def self.funeral_actions
    [
      {
        "type": "button",
        "text": "Ah, de boas",
        "url": "https://i.ytimg.com/vi/wEWF2xh5E8s/hqdefault.jpg",
        "style": "primary"
      },
      {
        "type": "button",
        "text": "NÃOOO :cry:",
        "url": "https://i.ytimg.com/vi/wEWF2xh5E8s/hqdefault.jpg",
        "style": "danger"
      }
    ]
  end
end
