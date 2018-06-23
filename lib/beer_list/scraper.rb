class Scraper

  def get_style_page
    doc = Nokogiri::HTML(open("https://www.beeradvocate.com/beer/style/"))
  end

  def create_parent_styles
    ParentStyle.new("Ale")
    ParentStyle.new("Lager")
  end

=begin
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
=end

  def create_sub_styles
    self.create_parent_styles
    #self.create_regions
    sub_styles = []
    self.get_style_page.css("table table").each do |info|
      if info.css("td span").text != "Hybrid Styles"
        parent_style_name = info.css("td span").text.split(" ")[0]
        info.css("td a").each do |beer_style|
          sub_styles << {
            :name => beer_style.text,
            :parent_style => ParentStyle.all.find {|style| style.name == parent_style_name},
            :url => beer_style.attribute('href').value
          }
        end
      end
    end
     sub_styles.each do |style_hash|
      style_hash[:parent_style].sub_styles << SubStyle.new(style_hash) unless SubStyle.all.any? {|sub_style| sub_style.name == style_hash[:name]}
    end
  end

  def get_beer_hash(doc, beer_list, sub_style)
    beer_list
    doc.css("tr").drop(3).each do |info|
      unless info.css("td a b").text == ""
        ratings = info.css("td b").collect {|child| child.text.gsub(",","") if child == info.css("td b")[1]}.reject! {|item| item == nil}.join.to_i
          if ratings > 99
            beer_list << {
              :name => info.css("td a b").text,
              :url => info.css("td a").attribute('href').value,
              :parent_style => sub_style.parent_style,
              :ratings => ratings,
              :score => info.css("td b").collect {|child| child.text if child == info.css("td b")[2]}.reject! {|text| text == nil}.join.to_f,
              :abv => info.css("td span").text.to_f
              }
            end
        end
    end
    beer_list
  end

  def get_ratings_array(doc)
      ratings_array = []
      doc.css("tr td b").drop(3).each do |ratings|
        ratings_array << ratings.text.gsub(",","").to_i if ratings.text.gsub(",","").to_i > 99 && ratings.text.split("").count < 7
      end
      ratings_array.pop if ratings_array.count > 1 && ratings_array[-1] > ratings_array[-2]
      ratings_array
  end

  def create_beers
    self.create_sub_styles
    beer_list = []
    SubStyle.all.each do |sub_style|
      beer_list.clear
      doc = Nokogiri::HTML(open("https://www.beeradvocate.com#{sub_style.url}?sort=avgD"))
        if doc.css("div#ba-content").text.split("\n")[3] != "No description, yet."
          description = doc.css("div#ba-content").text.split("\n")[3].split("Description:")[1].split("Average")[0].split("\r")[0].delete("\"").delete("/").gsub("\u0092","'").delete("\u0093").delete("\u0094")
        else
          description = doc.css("div#ba-content").text.split("\n")[3]
        end
        sub_style.add_desc(description)
        beer_list = self.get_beer_hash(doc, beer_list, sub_style)
        page_counter = 50
        counter = 20
        doc = Nokogiri::HTML(open("https://www.beeradvocate.com#{sub_style.url}?sort=revsD"))
          ratings_array = self.get_ratings_array(doc)
          counter = ratings_array.count if ratings_array.count < counter
        while beer_list.count < counter
          doc = Nokogiri::HTML(open("https://www.beeradvocate.com#{sub_style.url}?sort=avgD&start=#{page_counter}"))
            beer_list = self.get_beer_hash(doc, beer_list, sub_style)
            page_counter += 50
          end
          beer_list = beer_list[0..19]
          beer_list.each do |beer_hash|
            sub_style.style_beers << Beer.new(beer_hash) unless Beer.all.any? {|beer| beer.name == beer_hash[:name]}
          end
            #REMOVED ADD ATTRS FOR NEW Beers
    end
    Beer.all.each {|beer| beer.parent_style.beers << beer}
  end

  #doc = Nokogiri::HTML(open("https://www.beeradvocate.com/beer/style/128/?sort=avgD&start=1000"))


end

=begin
  --- ADD ATTR SECTION FOR CREATE_BEERS -----
sub_style.style_beers.each do |beer|
  doc = Nokogiri::HTML(open("https://www.beeradvocate.com#{beer.url}"))
  new_doc = doc.css("div#info_box").text.split("\n").each {|text| text.delete!("\t")}.reject {|text| text == ""}
  new_doc[-1] = new_doc[-1].split("Added by")[0]
  new_doc[6] = new_doc[6].split("Availability: ")[1]
  attr_hash = {
    :availability => new_doc[6],
    :brewery => new_doc[2],
    :description => new_doc[-1]
  }
  beer.add_attrs(attr_hash)
end
----------------------------------------------
=end


=begin
  ------- ORIGINAL DEF CREATE_BEERS ------------------
  def create_beers
    self.create_sub_styles
    beer_list = []
    SubStyle.all.each do |sub_style|
      beer_list.clear
        doc = Nokogiri::HTML(open("https://www.beeradvocate.com#{sub_style.url}?sort=avgD"))
        doc.css("tr").drop(3).each do |info|
          beer_list << {
            :name => info.css("td a b").text,
            :url => info.css("td a").attribute('href').value,
            :parent_style => sub_style.parent_style,
            :ratings => info.css("td b").collect {|child| child.text.gsub(",","") if child == info.css("td b")[1]}.reject! {|text| text == nil}.join.to_i,
            :score => info.css("td b").collect {|child| child.text if child == info.css("td b")[2]}.reject! {|text| text == nil}.join.to_f,
            :abv => info.css("td span").text.to_f
            } unless info.css("td a b").text == ""
        end
        beer_list.reject! {|beer_hash| beer_hash[:ratings] < 100}
        page_counter = 50
        counter = 20
        doc = Nokogiri::HTML(open("https://www.beeradvocate.com#{sub_style.url}?sort=revsD"))
          ratings_array = []
          doc.css("tr td b").drop(3).each do |ratings|
            ratings_array << ratings.text.gsub(",","").to_i if ratings.text.gsub(",","").to_i > 99 && ratings.text.split("").count < 7
          end
          ratings_array.pop if ratings_array.count > 1 && ratings_array[-1] > ratings_array[-2]
          counter = ratings_array.count if ratings_array.count < counter
        while beer_list.count < counter
          doc = Nokogiri::HTML(open("https://www.beeradvocate.com#{sub_style.url}?sort=avgD&start=#{page_counter}"))
          doc.css("tr").drop(3).each do |info|
            beer_list << {
              :name => info.css("td a b").text,
              :url => info.css("td a").attribute('href').value,
              :parent_style => sub_style.parent_style,
              :ratings => info.css("td b").collect {|child| child.text.gsub(",","") if child == info.css("td b")[1]}.reject! {|text| text == nil}.join.to_i,
              :score => info.css("td b").collect {|child| child.text if child == info.css("td b")[2]}.reject! {|text| text == nil}.join.to_f,
              :abv => info.css("td span").text.to_f
              } unless info.css("td a b").text == ""
            end
            beer_list.reject! {|beer_hash| beer_hash[:ratings] < 100}
            page_counter += 50
          end
          beer_list = beer_list[0..19]
          beer_list.each do |beer_hash|
            sub_style.style_beers << Beer.new(beer_hash) unless Beer.all.any? {|beer| beer.name == beer_hash[:name]}
          end
            #REMOVED ADD ATTRS FOR NEW Beers
    end
    Beer.all.each {|beer| beer.parent_style.beers << beer}
  end
  ---------------------------------------------------
=end

=begin
  ------------ ORIGINAL DEF CREATE_SUB_STYLES -----------------
  def create_sub_styles
    self.create_parent_styles
    #self.create_regions
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
    SubStyle.all.each do |sub_style|
      sub_style.parent_style.sub_styles << sub_style
    end
  end
  ------------------------------------------------------------
=end
