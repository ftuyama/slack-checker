class FuneralCall

  def self.send_message(message, probability: 1)
    Slack.send_message(message) if rand(probability) == 0

    puts message
  end

  def self.send_death_message(dead_name, dead_picture, dead_profile)
    message = "#{dead_profile} IS DEAD!!!!"

    Slack.send_message(message).tap do |slack_message|
      if slack_message
        thread = slack_message["ts"]

        Slack.send_image(dead_picture, reply: thread, label: dead_name, actions: funeral_actions())
        Slack.react(thread, "ok")
        Slack.react(thread, "crying_cat_face")
        Slack.react(thread, "no")
      end
    end

    puts message
  end

  def self.print_art(ascii_art_name, probability: 1)
    ascii_art = send(ascii_art_name)

    Slack.send_message(ascii_art) if rand(probability) == 0

    puts ascii_art
  end

  private

  def self.skull
    "```" + File.open("ascii/death#{rand(3)}", 'r').readlines.join() + "```"
  end

  def self.grave
    "```" + File.open("ascii/grave", 'r').readlines.join() + "```"
  end

  def self.head
    "```" + File.open("ascii/head", 'r').readlines.join() + "```"
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
