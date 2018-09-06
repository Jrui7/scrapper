# chopper toutes les pages des sous-categories pour afficher tous les produits de la sous catégories
require 'open-uri'
require 'nokogiri'

doc = Nokogiri::HTML(open("https://www.madine-france.com/fr/"))

filepath  = 'products.xml'
  builder   = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do
    categories do
      #get categories names
      categories = doc.css("ul.categories>li")
      categories.each do |category|
        text = category.css(">a").text
        puts text
        category "#{text}"
        subcategories do
          #get subcategories name
          subcategories = category.css("li>a")
          subcategories.each do |subcategory|
            subcategory "#{subcategory.text}"
            puts subcategory
            #get different links of sub-cat
            pages do
              subcategory_link = subcategory['href']
              subcategory_pages = []
              subcategory_url = Nokogiri::HTML(open("https://www.madine-france.com/#{subcategory_link}"))
              subcategory_pages << subcategory_link
              if subcategory_url.at_css(".navd")
                links = subcategory_url.css(".pagination")[0].css("span>a").count - 1
                turn = 0
                while turn < links
                 subcategory_pages << subcategory_url.css(".pagination")[0].css("span>a")[turn]["href"]
                 turn += 1
                end
              else
                puts "il n'y a pas d'autres pages"
              end

              subcategory_pages.each do |page|
                lien = Nokogiri::HTML(open("https://www.madine-france.com/#{page}"))
                entries = lien.css('h2')
                entries.each do |entry|
                  if entry.at_css("a")
                    extension = entry.css('a')[0]['href']
                    page = Nokogiri::HTML(open("https://www.madine-france.com/fr/#{extension}"))
                    if page.at_css('.track-url')
                      link = page.css('.track-url')[0]['href']
                      puts link
                      url        "#{link}"
                    end
                  end
                end
              end

            end
          end

        end
      end

    end
  end

File.open(filepath, 'wb') { |file| file.write(builder.to_xml) }





# filepath  = 'products.xml'
#   builder   = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do
#     product do
#       entries.each do |entry|
#         extension = entry.css('a')[0]['href']
#         page = Nokogiri::HTML(open("https://www.madine-france.com/fr/#{extension}"))
#         link = page.css('.track-url')[0]['href']
#         puts link
#         url        "#{link}"
#       end
#     end
#   end





# subcategory_link = subcategory.css('a')[0]['href']
# #ligne 1 dans le xml: nom de la sub-catégorie
# subcategory_name = subcategory.css('a').text
# subcategory_pages = []
# subcategory_url = Nokogiri::HTML(open("https://www.madine-france.com/#{subcategory_link}"))
# subcategory_pages << subcategory_link



# #s'il ya d'autres pages sur la catégorie, les prendre
# if subcategory_url.at_css(".navd")
#   links = subcategory_url.css(".pagination")[0].css("span>a").count - 1
#   turn = 0
#   while turn < links
#    subcategory_pages << subcategory_url.css(".pagination")[0].css("span>a")[turn]["href"]
#    turn += 1
#   end
# else
#   puts "il n'y a pas de sous catégories"
# end

# puts subcategory_pages

