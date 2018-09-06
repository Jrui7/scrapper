# chopper toutes les pages des sous-categories pour afficher tous les produits de la sous catégories
require 'open-uri'
require 'nokogiri'
require 'pry'

doc = Nokogiri::HTML(open("https://www.madine-france.com/fr/"))

noko = []
c = 1
s = 1

#get categories names
categories = doc.css("ul.categories>li")
categories.each do |cat|
  category = cat.css(">a").text #à insérer
  #get subcategories name
  subcategories = cat.css("li>a")
  subcategories.each do |subcat|
    puts "categories #{c}/#{categories.count}"
    subcategory = subcat.text #à insérer

    #get different links of sub-cat
    subcategory_link = subcat['href']
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
    end

    subcategory_pages.each do |page|
      lien = Nokogiri::HTML(open("https://www.madine-france.com/#{page}"))
      products = lien.css(".fabricant")
      products.each do |product|
        entry = product.css('h2')
        description = product.css("p").text
        if entry.at_css("a")
          extension = entry.css('a')[0]['href']
          page = Nokogiri::HTML(open("https://www.madine-france.com/fr/#{extension}"))
          if page.at_css('.track-url')
            #get product website link
            link = page.css('.track-url')[0]['href'] #à insérer
          end
          object = {category: category, subcategory: subcategory, link: link, description: description}
          noko << object
        end
      end
    end
    puts "subcategorie #{s}/#{subcategories.count}"
    puts "--------------------------------"
    s += 1
  end #subcategory name
  c += 1
  s = 1
end #category name

puts "finished"

doc = Nokogiri::HTML(open("https://www.madine-france.com/fr/"))

filepath  = 'products.xml'
  builder   = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
    xml.root {
      xml.products {
        noko.each do |object|
          xml.object {
            xml.category object[:category]
            xml.subcategory object[:subcategory]
            xml.link object[:link]
            xml.description object[:description]
          }
        end
      }
    }
  end

File.open(filepath, 'wb') { |file| file.write(builder.to_xml) }




