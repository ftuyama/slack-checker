class DB
  FILES = {
    alive: 'db/alive.txt',
    channels: 'db/channels.json',
    groups: 'db/groups.json',
    messages: 'db/messages.json',
    profile: 'db/profile/',
    users: 'db/users.json',
  }

  attr_accessor :file

  def initialize(file = FILES[:alive])
    self.file = file
  end

  def load
    File.open(self.file).readlines.map(&:strip)
  end

  def save(data)
    File.open(self.file, "w+") { |f| f.puts(data) }
  end

  def save_json(data)
    File.open(self.file, "w+") { |f| f << data.to_json }
    data
  end

  def load_json
    File.open(self.file) { |f| JSON.parse(f.read) }
  end

  def date
    begin
      File.mtime(self.file)
    rescue
      Time.parse("1994-11-10") # beginning of time
    end
  end

  def older_than(time_elapsed)
    Time.now - date() > time_elapsed
  end
end
