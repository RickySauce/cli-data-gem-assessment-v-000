class ParentStyle
  attr_accessor :name, :sub_styles, :beers
    @@all = []

    def initialize(name)
      @name = name
      @@all << self
      @sub_styles = []
      @beers = []
    end

    def self.all
      @@all
    end
end
