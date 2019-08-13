class Member
  attr_accessor :id, :name, :picture, :original_picture, :profile, :deleted, :updated, :data

  def initialize(data)
    @id = data["id"]
    @name = data["name"] || data["profile"]["real_name"] || data["real_name"]
    @title = data["profile"]["title"]
    @original_picture = data["profile"]["image_original"]
    @picture = data["profile"]["image_192"]
    @deleted = data["deleted"]
    @updated = data["updated"]
    @data = data
  end

  def death_time
    Time.at(@updated).strftime("%F %T")
  end

  def picture_time
    begin
      picture_time = @original_picture.scan(/(\d{4}-\d{2}-\d{2})/).last.first
      Date.strptime(picture_time, "%Y-%m-%d").to_time.to_i
    rescue
      nil
    end
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
    "#{death_time} - #{@name.ljust(24, ' ')} - #{title_badge.ljust(40, ' ')} - #{@picture}"
  end

  def profile_linked_label
    "#{death_time} - <@#{@id}> - #{title_badge}"
  end

  def title_badge
    unless @title.nil? && @title != ""
      " [#{@title}]"
    else
      ""
    end
  end
end
