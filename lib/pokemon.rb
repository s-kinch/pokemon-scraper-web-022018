class Pokemon
  attr_accessor :id, :name, :type, :db, :hp

  def initialize(id: nil, name: nil, type: nil, db: nil, hp: nil)
    @id = id
    @name = name
    @type = type
    @db = db
    @hp = hp
  end

  def self.save(name, type, db)
    pok = Pokemon.new(name: name, type: type)
    sql = <<-SQL
      INSERT INTO pokemon (name, type) VALUES (
        ?, ?
      );
    SQL
    db.execute(sql, name, type)
    pok.id = db.execute("SELECT last_insert_rowid() FROM pokemon")[0][0]
  end

  def self.find(id, db)
    db.results_as_hash = true
    info = db.execute("SELECT * FROM pokemon WHERE id = ?", id)[0]
    self.new(name: info["name"],type: info["type"],id: info["id"], hp: info["hp"])
  end

  def alter_hp(new_hp, db)
    db.execute("UPDATE pokemon SET hp = ? WHERE id = ?", new_hp, self.id)
  end

end
