class DB
  DB_FILE = 'db/alive.txt'

  def self.load
    File.open(DB_FILE).readlines.map(&:strip)
  end

  def self.save(data)
    File.open(DB_FILE, "w+") { |f| f.puts(data) }
  end
end
