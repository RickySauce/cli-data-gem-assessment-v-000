class Scraper

  def get_style_page
    doc = Nokogiri::HTML(open("https://www.beeradvocate.com/beer/style/"))
  end

  def create_parent_styles
    lager = ParentStyle.new("Lager")
    ale = ParentStyle.new("Ale")
  end

  def create_regions
    self.get_style_page.css("table td b").each do |region_name|
      new_region_name = region_name.text
      region_split = new_region_name.split(" ")
      if region_split[1] == "Ales"
        new_region_name.gsub!(" Ales", " Beers")
      elsif region_split[1] == "Lagers"
        new_region_name.gsub!(" Lagers", " Beers")
      end
      Region.new(new_region_name) unless Region.all.any? {|region| region.name == new_region_name}
    end
  end


  def create_sub_styles
    self.create_parent_styles
    sub_styles = []
    self.get_style_page.css("table table").each do |info|
      if info.css("span").text == "Ale Styles"
        info.css("td a").each do |beer_style|
          sub_styles << {
            :name => beer_style.text,
            :parent_style => ParentStyle.all.find {|style| style.name == "Ale"},
            :url => beer_style.attribute('href').value
          }
        end
      elsif info.css("span").text == "Lager Styles"
        info.css("td a").each do |beer_style|
          sub_styles << {
            :name => beer_style.text,
            :parent_style => ParentStyle.all.find {|style| style.name == "Lager"},
            :url => beer_style.attribute('href').value
          }
        end
      end
    end
    sub_styles.each do |style_hash|
      SubStyle.new(style_hash) unless SubStyle.all.any? {|sub_style| sub_style.name == style_hash[:name]}
    end
  end

  def create_beers
    self.create_sub_styles
    beer_list = []
    SubStyle.all.each do |sub_style|
        doc = Nokogiri::HTML(open("https://www.beeradvocate.com#{sub_style.url}?sort=avgD"))
         doc.css("tr td a").each do |info|
           beer_list << { 
             :name => info.css("b").text,
             :url => info.attribute('href').value,
             :parent_style => sub_style.parent_style    
           }
        end
        beer_list.reject! do |hash|
        hash[:name] == ""
      end
    end
    beer_list.each do |beer_hash|
      Beer.new(beer_hash) unless Beer.all.any? {|beer| beer.name == beer_hash[:name]}
    end
   end
    
    

end

=begin
students << {
        :name => student_info.css("div.card-text-container h4.student-name").text,
        :location => student_info.css("div.card-text-container p.student-location").text,
        :profile_url => student_info.css("a").collect  { |link| link['href'] }.join
        }
=end

=begin
sub_style_ales = nil
sub_style_lagers = nil
self.get_style_page.css("table table").each do |info|
  if info.css("span").text == "Ale Styles"
    sub_style_ales = info.css("td a").collect {|beer_style| beer_style.text}
  elsif info.css("span").text == "Lager Styles"
    sub_style_lagers = info.css("td a").collect {|beer_style| beer_style.text}
    binding.pry
  end
end
=end
