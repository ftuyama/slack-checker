class Member
  attr_accessor :name, :picture, :deleted, :updated

  def initialize(data)
    @name = data["name"] || data["profile"]["real_name"] || data["real_name"]
    @title = data["profile"]["title"]
    @picture = data["profile"]["image_72"]
    @deleted = data["deleted"]
    @updated = data["updated"]
  end

  def death_time
    Time.at(@updated).strftime("%F %T")
  end

  def profile
    "#{death_time} - #{@name} - #{title_badge}"
  end

  def title_badge
    unless @title.nil? && @title != ""
      " [#{@title}]"
    else
      ""
    end
  end
end
