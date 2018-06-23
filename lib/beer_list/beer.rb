

class Beer
  attr_accessor :name, :sub_style, :parent_style, :region, :availability, :abv, :url, :score, :ratings, :brewery, :description, :attributes
  @@all = []

  def initialize(beer_hash)
    beer_hash.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
    @attributes = beer_hash
  end

  def get_attrs
    doc = Nokogiri::HTML(open("https://www.beeradvocate.com#{self.url}"))
    new_doc = doc.css("div#info_box").text.split("\n").each {|text| text.delete!("\t")}.reject {|text| text == ""}
    new_doc[-1] = new_doc[-1].split("Added by")[0]
    new_doc[6] = new_doc[6].split("Availability: ")[1]
    attr_hash = {
      :availability => new_doc[6],
      :brewery => new_doc[2],
      :description => new_doc[-1]
    }
    self.add_attrs(attr_hash)
  end

  def add_attrs(attr_hash)
    unless attr_hash.any? {|key, value| value == self.availability}
      attr_hash.each {|key, value| self.send(("#{key}="), value)}
      attr_hash.each {|key, value| self.attributes[key] = value}
    end
  end

  def self.all
    @@all
  end

  def list_info
    @attributes.each {|key, value| puts "#{key.gsub(":","")}: #{value}" if key != :name}
  end
end
