#CLI Controller

class BeerList::CLI

  def call
    menu
  end

  def menu
    puts "GREETINGS USER!"
    puts "BEER-LIST IS AN INTERACTIVE APP WHICH PULLS IT'S INFORMATION DIRETLY"
    puts "FROM BEERADVOCATE.COM"
    puts "IT THEN RETURNS TOP 20 LISTS BASED ON BEERS - BEERADVOCATE SCORES"
    puts "(BA-SCORE), WITH NO FEWER THAN 100 RATINGS"
    puts "PLEASE ENTER THE CORRESPONDING NUMBER FOR THE FOLLOWING OPTIONS"
    puts "HOW WOULD YOU LIKE TO SORT YOUR BEER LIST?"
    puts "1. LIST THE TOP BEERS IN THE WORLD"
    puts "2. CHOOSE BY SUBSTYLE"
    puts "3. SEPERATE BETWEEN ALES AND LAGERS"
    puts "COMING SOON: CHOOSE BY REGION"
    puts "OTHERWISE, ENTER 'EXIT'"
    answer = self.input
      case answer
      when "1"
        answer_1
      when "2"
        answer_2
      when "3"
        answer_3
      when "main"
        menu
      else
        puts "GOODBYE"
        exit
    end
  end

  def answer_1
    beer_list = self.top_beers
    self.list_beer_score(beer_list)
    puts
    self.sorting_method
    answer = self.input
    case answer
    when "1"
      self.list_beer_abv(beer_list)
      puts
      self.more_options
    when "2"
      self.list_beer_ratings(beer_list)
      puts
      self.more_options
    when "main"
      menu
    else
      puts "GOODBYE"
      exit
    end
 end

 def answer_2
   self.list_sub_styles
   puts
   puts "PLEASE SELECT THE NUMBER THAT CORRESPONDS WITH THE SUBSTYLE OF CHOICE"
   saved_input = input
   self.list_sub_style_score(saved_input)
   puts
   self.sorting_method
   puts
   answer = self.input
   case answer
   when "1"
     self.list_sub_style_abv(saved_input)
     puts
     self.more_options
   when "2"
     self.list_sub_style_ratings(saved_input)
     puts
     self.more_options
   when "main"
     menu
   else
     puts "GOODBYE"
     exit
   end
 end

 def answer_3
   self.list_parent_styles
   puts
   puts "PLEASE SELECT THE NUMBER THAT CORRESPONDS WITH THE PARENT STYLE OF CHOICE"
   answer = input
   saved_input = answer
   case answer
   when "1"
     puts "PLEASE SELECT THE NUMBER THAT CORRESPONDS WITH YOUR SORTING METHOD OF CHOICE"
     puts "1. SORT BEERS BY THIS PARENT STYLE"
     puts "2. SORT SUB-STYLES BY THIS PARENT STYLE"
     answer = input
     case answer
     when "1"
       self.list_parent_style_beer_score(saved_input)
     when "2"
       self.list_parent_style_sub_styles(saved_input)
     end
   when "2"
     #experimenting
   end

end


  def sorting_method
    puts "WOULD YOU LIKE TO FURTHER SORT?"
    puts "IF SO SELECT THE NUMBER THAT CORRESPONDS"
    puts "WITH YOUR SORTING METHOD OF CHOICE"
    puts "OTHERWISE TYPE 'MAIN' TO RETURN TO THE MAIN MENU OR 'EXIT' TO LEAVE"
    puts "1. SORT BY ABV"
    puts "2. SORT BY TOTAL REVIEWS"
  end

  def more_options
    puts "WOULD YOU LIKE TO SEE MORE LISTS?"
    puts "ENTER 'MAIN' TO DO SO, OTHERWISE TYPE 'EXIT'"
    answer = self.input
    case answer
    when "main"
      menu
    else
      puts "GOODBYE"
      exit
    end
  end

  def input
    gets.strip.downcase
  end

   def list_parent_styles
     ParentStyle.all.each_with_index do |parent_style, index|
       puts "#{index + 1}. #{parent_style.name}"
     end
   end

   def list_parent_style_beer_score(answer)
     choice = ParentStyle.all[answer.to_i - 1]
     list = choice.beers.sort_by {|beer| beer.score}.reverse
     puts "SHOWING ALL #{choice.name.upcase}'S SORTED BY BA-SCORE"
     list.each_with_index do |beer, index|
       puts "#{index + 1}. #{beer.name} #{beer.score}"
     end
   end

   def list_parent_style_sub_styles(answer)
     choice = ParentStyle.all[answer.to_i - 1]
     puts "SHOWING ALL #{choice.name.upcase}'S SUB-STYLES"
     choice.sub_styles.each_with_index do |sub_style, index|
        puts "#{index + 1}. #{sub_style.name}"
      end
   end

   def list_sub_styles
     SubStyle.all.each_with_index do |sub_style, index|
       puts "#{index + 1}. #{sub_style.name}"
     end
   end

   def list_sub_style_score(answer)
    choice = SubStyle.all[answer.to_i - 1]
    list = choice.style_beers.sort_by {|beer| beer.score}.reverse
    puts "SHOWING ALL #{choice.name.upcase}'S SORTED BY BA-SCORE"
    list.each_with_index do |beer, index|
      puts "#{index + 1}. #{beer.name} #{beer.score}"
    end
    puts ""
    puts "SORRY. LIMITED INFORMATION FOR YOUR SELECTED SUB-STYLE" if list.count < 10
   end

   def list_sub_style_abv(answer)
     choice = SubStyle.all[answer.to_i - 1]
     list = choice.style_beers.sort_by {|beer| beer.abv}.reverse
     puts "SHOWING ALL #{choice.name.upcase}'S SORTED BY ABV"
     list.each_with_index do |beer, index|
       puts "#{index + 1}. #{beer.name} #{beer.abv}%"
     end
     puts ""
     puts "SORRY. LIMITED INFORMATION FOR YOUR SELECTED SUB-STYLE" if list.count < 10
   end

   def list_sub_style_ratings(answer)
     choice = SubStyle.all[answer.to_i - 1]
     list = choice.style_beers.sort_by {|beer| beer.ratings}.reverse
     puts "SHOWING ALL #{choice.name.upcase}'S SORTED BY TOTAL ratings"
     list.each_with_index do |beer, index|
       puts "#{index + 1}. #{beer.name} #{beer.ratings}"
     end
     puts ""
     puts "SORRY. LIMITED INFORMATION FOR YOUR SELECTED SUB-STYLE" if list.count < 10
   end

    def top_beers
      Beer.all.sort_by {|beer| beer.score}.reverse
    end

   def list_beer_score(beer_list)
     puts "SHOWING ALL BEER SORTED BY BA-SCORE"
     #beer_list = beer_list[0..19]
     beer_list.each_with_index do |beer, index|
      puts "#{index + 1}. #{beer.name} #{beer.score}"
     end
   end

   def list_beer_abv(beer_list)
    beer_list.sort_by {|beer| beer.abv}.reverse!
     puts "SHOWING ALL BEER SORTED BY ABV"
     #beer_list = beer_list[0..19]
    beer_list.each_with_index do |beer, index|
      puts "#{index + 1}. #{beer.name} #{beer.abv}%"
     end
   end

   def list_beer_ratings(beer_list)
     beer_list.sort_by {|beer| beer.ratings}.reverse!
     puts "SHOWING ALL BEER SORTED BY RATINGS"
     #beer_list = beer_list[0..19]
    beer_list.each_with_index do |beer, index|
      puts "#{index + 1}. #{beer.name} #{beer.ratings}"
     end
   end

end


=begin
def list_regions
  Region.all.each_with_index do |region, index|
    puts "#{index + 1}. #{region.name}"
  end
end
=end
