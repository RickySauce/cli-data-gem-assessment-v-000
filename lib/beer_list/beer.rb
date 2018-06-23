

class Beer
  attr_accessor :name, :sub_style, :parent_style, :region, :availability, :abv, :url, :score, :ratings, :brewery, :description, :attributes
  @@all = []

  def initialize(beer_hash)
    beer_hash.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
    @attributes = beer_hash
  end

  def add_attrs(attr_hash)
    attr_hash.each {|key, value| self.send(("#{key}="), value)}
  end

  def self.all
    @@all
  end

  def list_info
    @attributes.each {|key, value| puts "#{key.gsub(":","")}: #{value}" if key != :name}
  end
end
