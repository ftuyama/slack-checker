class Member
  attr_accessor :id, :name, :picture, :profile, :deleted, :updated, :data

  def initialize(data)
    @id = data["id"]
    @name = data["name"] || data["profile"]["real_name"] || data["real_name"]
    @title = data["profile"]["title"]
    @picture = data["profile"]["image_192"]
    @deleted = data["deleted"]
    @updated = data["updated"]
    @data = data
  end

  def death_time
    Time.at(@updated).strftime("%F %T")
  end

  def birth_time
    @profile || fetch_profile()

    begin
      birth_date = @profile["fields"]["Xf0KJK2Z4Y"]["value"]
      Date.strptime(birth_date, "%Y-%m-%d").to_time.to_i
    rescue
      nil
    end
  end

  def fetch_profile
    @profile = SlackCache.fetch_with_params(:profile, @id)
  end

  def profile_label
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
