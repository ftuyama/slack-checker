class DB
  FILES = {
    alive: 'db/alive.txt',
    messages: 'db/messages.txt',
    users: 'db/users.txt',
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
    File.mtime(self.file)
  end

  def older_than(time_elapsed)
    Time.now - date() > time_elapsed
  end
end