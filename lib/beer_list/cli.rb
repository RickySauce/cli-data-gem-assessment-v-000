#CLI Controller

class BeerList::CLI

  def call
    menu
  end

  def create_parent_styles
    lager = ParentStyle.new("Lager")
    ale = ParentStyle.new("Ale")
  end

  def menu
    puts "GREETINGS USER!"
    puts "PLEASE ENTER THE CORRESPONDING NUMBER FOR THE FOLLOWING OPTIONS"
    puts "HOW WOULD YOU LIKE TO SORT YOUR BEER LIST?"
    puts "1. LIST THE TOP BEERS IN THE WORLD"
    puts "2. SEPERATE BETWEEN ALES AND LAGERS"
    puts "3. CHOOSE BY REGION"
    puts "4. CHOOSE BY SUBSTYLE"
    puts "OTHERWISE, ENTER 'EXIT'"
    answer = nil
    while answer != "exit"
      answer = gets.strip
      if answer == "1"
         puts "1"
      elsif answer == "2"
        puts "PLEASE SELECT THE NUMBER THAT CORRESPONDS WITH THE STYLE OF CHOICE"
        puts "OTHERWISE ENTER 'EXIT' TO LEAVE OR 'MAIN' TO RETURN TO THE MAIN MENU"
        self.list_parent_styles
      elsif answer == "3"
        puts "PLEASE SELECT THE NUMBER THAT CORRESPONDS WITH THE REGION OF CHOICE"
        puts "OTHERWISE ENTER 'EXIT' TO LEAVE OR 'MAIN' TO RETURN TO THE MAIN MENU"
        self.list_regions
      elsif answer == "4"
        puts "PLEASE SELECT THE NUMBER THAT CORRESPONDS WITH THE REGION OF CHOICE"
        puts "OTHERWISE ENTER 'EXIT' TO LEAVE OR 'MAIN' TO RETURN TO THE MAIN MENU"
        self.list_sub_styles
      end
     end
   end

   def list_regions
     Region.all.each_with_index do |region, index|
       puts "#{index += 1}. #{region.name}"
     end
   end

   def list_parent_styles
     puts "1. Ales"
     puts "2. Lagers"
   end

   def list_sub_styles
     SubStyle.all.each_with_index do |sub_style, index|
       puts "#{index += 1}. #{sub_style.name}"
     end
   end
   
end
