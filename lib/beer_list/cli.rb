#CLI Controller

class BeerList::CLI

  def call
    menu
  end

  def menu
    puts "GREETINGS USER!"
    puts "BEER-LIST IS AN INTERACTIVE APP WHICH PULLS IT'S INFORMATION DIRECTLY"
    puts "FROM BEERADVOCATE.COM"
    puts "IT THEN RETURNS TOP 20 LISTS BASED ON BEER-ADVOCATE SCORES"
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
        answer_beers
      when "2"
        answer_sub_styles
      when "3"
        answer_parent
      when "main"
        menu
      else
        puts "GOODBYE"
        exit
    end
  end

  def answer_beers
    beer_list = self.top_beers
    self.list_beer_score(beer_list)
    puts "SELECT A NUMBER THAT CORRESPONDS WITH THE BEER OF CHOICE FOR MORE INFO"
    puts "OTHERWISE ENTER 'MORE' FOR MORE OPTIONS"
    puts
    answer = self.input
    if answer == 'more'
      self.sorting_method_beer(beer_list)
    elsif
      self.beer_info(beer_list,answer)
    end
 end

 def answer_sub_styles
   answer = input
   puts "PLEASE SELECT THE NUMBER THAT CORRESPONDS WITH ONE OF THE FOLLOWING:"
   puts "1. CREATE A CUSTOM LIST OF TWO OR MORE SUB-STYLES"
   puts "2. CREATE A LIST FROM A SINGLE SUB-STYLE"
   puts "ELSE, ENTER 'EXIT' TO LEAVE OR 'MAIN' FOR THE MAIN MENU"
   case answer
   when "1"
     self.list_sub_styles
     puts "PLEASE SELECT THE AMOUNT OF SUB-STYLES YOU WISH TO USE"
     puts
     answer = input
     beer_list = self.get_sub_style_selections(answer)
     beer_list = self.combination_top_beers(beer_list)
     self.list_beer_score(beer_list)
     puts
     self.sorting_method_beer(beer_list)
   when "2"
     self.list_sub_styles
     puts
     puts "PLEASE SELECT THE NUMBER THAT CORRESPONDS WITH THE SUBSTYLE OF CHOICE"
     saved_input = input
     self.list_sub_style_score(saved_input)
     puts
     self.sorting_method_sub_style(saved_input)
   when "main"
     menu
   else
     puts "GOODBYE"
     exit
   end
 end

def answer_parent
  self.list_parent_styles
  puts
  puts "PLEASE SELECT THE NUMBER THAT CORRESPONDS WITH THE STYLE OF CHOICE"
  saved_choice = parent_choice(input)
  puts
  puts "PLEASE ENTER THE NUMBER THAT CORRESPONDS WITH THE ONE OF THE OPTIONS"
  puts "1. LIST TOP BEERS OF THE SELECTED PARENT STYLE"
  puts "2. LIST ALL SUB-STYLES BELONGING TO THE SELECTED PARENT STYLE"
  puts "OTHERWISE ENTER 'EXIT' TO LEAVE OR 'MAIN' TO RETURN TO THE MAIN MENU"
  answer = input
  case answer
  when "1"
    beer_list = parent_top_beers(saved_choice)
    self.list_parent_style_beer_score(beer_list,saved_choice)
    puts
    self.sorting_method_parent(saved_choice, beer_list, nil)
  when "2"
    self.list_parent_style_sub_styles(saved_choice)
    puts
    puts "PLEASE SELECT THE NUMBER THAT CORRESPONDS WITH THE SUB-STYLE OF CHOICE"
    saved_input = input
    puts
    self.list_parent_sub_style_score(saved_input, saved_choice)
    puts
    self.sorting_method_parent(saved_choice, nil, saved_input)
  when "main"
    menu
  else
    puts "GOODBYE"
    exit
  end
end



def sorting_method_parent(saved_choice, beer_list = nil, saved_input = nil)
  puts "WOULD YOU LIKE TO FURTHER SORT?"
  puts "IF SO SELECT THE NUMBER THAT CORRESPONDS"
  puts "WITH YOUR SORTING METHOD OF CHOICE"
  puts "OTHERWISE TYPE 'MAIN' TO RETURN TO THE MAIN MENU OR 'EXIT' TO LEAVE"
  puts "1. SORT BY ABV"
  puts "2. SORT BY TOTAL REVIEWS"
  if beer_list == nil
    case answer
    when "1"
      self.list_parent_sub_style_abv(saved_input, saved_choice)
      puts
      self.more_options
    when "2"
      self.list_parent_sub_style_ratings(saved_input, saved_choice)
      puts
      self.more_options
    when "main"
      menu
    else
      puts "GOODBYE"
      exit
    end
  else saved_input == nil
    case answer
    when "1"
      self.list_parent_style_beer_abv(beer_list, saved_choice)
      puts
      self.more_options
    when "2"
      self.list_parent_style_beer_ratings(beer_list, saved_choice)
      puts
      self.more_options
    when "main"
      menu
    else
      puts "GOODBYE"
      exit
    end
  end
end

def sorting_method_sub_style(saved_input)
  puts "WOULD YOU LIKE TO FURTHER SORT?"
  puts "IF SO SELECT THE NUMBER THAT CORRESPONDS"
  puts "WITH YOUR SORTING METHOD OF CHOICE"
  puts "OTHERWISE TYPE 'MAIN' TO RETURN TO THE MAIN MENU OR 'EXIT' TO LEAVE"
  puts "1. SORT BY ABV"
  puts "2. SORT BY TOTAL REVIEWS"
  answer = self.input
  case answer
  when "1"
    self.list_sub_style_abv(saved_input)
    puts
    self.more_options
  when "2"
    self.list_sub_style_ratings(saved_input)
  when "main"
    menu
  else
    puts "GOODBYE"
    exit
  end
end

  def sorting_method_beer(beer_list)
    puts "WOULD YOU LIKE TO FURTHER SORT?"
    puts "IF SO SELECT THE NUMBER THAT CORRESPONDS"
    puts "WITH YOUR SORTING METHOD OF CHOICE"
    puts "OTHERWISE TYPE 'MAIN' TO RETURN TO THE MAIN MENU OR 'EXIT' TO LEAVE"
    puts "1. SORT BY ABV"
    puts "2. SORT BY TOTAL REVIEWS"
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

   def parent_top_beers(choice)
     choice.beers.sort_by {|beer| beer.score}.reverse[0..19]
   end

   def parent_choice(answer)
     ParentStyle.all[answer.to_i - 1]
   end

   def list_parent_style_beer_score(beer_list, choice)
     puts "SHOWING ALL #{choice.name.upcase}'S SORTED BY BA-SCORE"
     beer_list.each_with_index do |beer, index|
       puts "#{index + 1}. #{beer.name}: #{beer.score}"
     end
   end

   def list_parent_style_beer_abv(beer_list, choice)
     list = beer_list.sort_by {|beer| beer.abv}.reverse
     puts "SHOWING ALL #{choice.name.upcase}'S SORTED BY ABV"
     self.abv_list(list)
   end

   def list_parent_style_beer_ratings(beer_list, choice)
     list = beer_list.sort_by {|beer| beer.ratings}.reverse
     puts "SHOWING ALL #{choice.name.upcase}'S SORTED BY RATINGS"
     self.ratings_list(list)
   end

   def list_parent_style_sub_styles(choice)
     puts "SHOWING ALL #{choice.name.upcase}'S SUB-STYLES"
     choice.sub_styles.each_with_index do |sub_style, index|
        puts "#{index + 1}. #{sub_style.name}"
      end
   end

   def list_parent_sub_style_score(answer, parent_choice)
     choice = parent_choice.sub_styles[answer.to_i - 1]
     list = choice.style_beers.sort_by {|beer| beer.score}.reverse
      puts "SHOWING ALL #{choice.name.upcase}'S SORTED BY BA-SCORE"
     self.score_list(list)
   end

   def list_parent_sub_style_abv(answer, parent_choice)
     choice = parent_choice.sub_styles[answer.to_i - 1]
     list = choice.style_beers.sort_by {|beer| beer.abv}.reverse
     puts "SHOWING ALL #{choice.name.upcase}'S SORTED BY ABV"
     self.abv_list(list)
   end

   def list_parent_sub_style_ratings(answer, parent_choice)
     choice = parent_choice.sub_styles[answer.to_i - 1]
     list = choice.style_beers.sort_by {|beer| beer.ratings}.reverse
     puts "SHOWING ALL #{choice.name.upcase}'S SORTED BY ratings"
     self.ratings_list(list)
   end

   def list_sub_styles
     SubStyle.all.each_with_index do |sub_style, index|
       puts "#{index + 1}. #{sub_style.name}"
     end
   end

   def get_sub_style_selections(answer)
     puts "YOU WILL NOW BE ALLOWED TO CHOOSE YOUR SELECTIONS FROM THE MENU ABOVE"
     count = answer.to_i
     count = 1 if answer.to_i > 100
     count_array = Array.new(count,"")
     style_selections = []
     count_array.each do |selection|
        puts "YOU HAVE #{count} SELECTIONS REMAINING"
       input = gets.strip
       while input.to_i < 1 || SubStyle.all[input.to_i] == nil
         puts "PLEASE SELECT ANOTHER NUMBER. MAKE SURE THAT NUMBER CORRESPONDS WITH AN EXISTING SUB-STYLE"
         input = gets.strip
       end
       style_selections << input.to_i - 1
       count -= 1
     end
     self.get_sub_style_total(style_selections.uniq)
   end

   def get_sub_style_total(style_selections)
     beer_list = []
     style_selections.each do |index|
       counter = 1
       puts "SELECTION #{counter}: #{SubStyle.all[index].name}"
       beer_list << SubStyle.all[index].style_beers
       counter += 1
     end
     beer_list.flatten
   end

   def combination_top_beers(beer_list)
     beer_list.sort_by {|beer| beer.score}.reverse[0..19]
   end


   def list_sub_style_score(answer)
    choice = SubStyle.all[answer.to_i - 1]
    list = choice.style_beers.sort_by {|beer| beer.score}.reverse
    puts "SHOWING ALL #{choice.name.upcase}'S SORTED BY BA-SCORE"
    self.score_list(list)
   end

   def list_sub_style_abv(answer)
     choice = SubStyle.all[answer.to_i - 1]
     list = choice.style_beers.sort_by {|beer| beer.abv}.reverse
     puts "SHOWING ALL #{choice.name.upcase}'S SORTED BY ABV"
     self.abv_list(list)
   end

   def list_sub_style_ratings(answer)
     choice = SubStyle.all[answer.to_i - 1]
     list = choice.style_beers.sort_by {|beer| beer.ratings}.reverse
     puts "SHOWING THE TOP 20 BEERS OF #{choice.name.upcase}'S SORTED BY TOTAL ratings"
     self.ratings_list(list)
   end

    def top_beers
      Beer.all.sort_by {|beer| beer.score}.reverse[0..19]
    end

   def list_beer_score(beer_list)
     puts "SHOWING THE TOP 20 BEERS IN THE WORLD SORTED BY BA-SCORE:"
     beer_list.each_with_index do |beer, index|
      puts "#{index + 1}. #{beer.name}: #{beer.score}"
     end
   end

   def list_beer_abv(beer_list)
     list = beer_list.sort_by {|beer| beer.abv}.reverse
     puts "SHOWING THE TOP 20 BEERS IN THE WORLD SORTED BY ABV:"
     self.abv_list(list)
   end

   def list_beer_ratings(beer_list)
     list = beer_list.sort_by {|beer| beer.ratings}.reverse
     puts "SHOWING THE TOP 20 BEERS IN THE WORLD SORTED BY RATINGS:"
     self.ratings_list(list)
   end

   def score_list(list)
     beer_list.each_with_index do |beer, index|
      puts "#{index + 1}. #{beer.name}: #{beer.score}"
     end
     puts
     puts "SORRY. LIMITED INFORMATION FOR YOUR SELECTED SUB-STYLE" if list.count < 10
   end

   def abv_list(list)
     list.each_with_index do |beer, index|
       puts "#{index + 1}. #{beer.name}: #{beer.abv}%"
      end
      puts
      puts "SORRY. LIMITED INFORMATION FOR YOUR SELECTED SUB-STYLE" if list.count < 10
   end

   def ratings_list(list)
     list.each_with_index do |beer, index|
       puts "#{index + 1}. #{beer.name}: #{beer.ratings}"
     end
     puts
     puts "SORRY. LIMITED INFORMATION FOR YOUR SELECTED SUB-STYLE" if list.count < 10
   end

   def beer_info(beer_list, input)
     if input.to_i < 1 || input.to_i > 19
        index = 0
     else
       index = input.to_i - 1
     end
     puts "#{beer_list[index].name}"
     puts
     beer_list[index].list_info
   end

end


=begin
def list_regions
  Region.all.each_with_index do |region, index|
    puts "#{index + 1}. #{region.name}"
  end
end
=end
