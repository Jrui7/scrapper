# chopper toutes les pages des sous-categories pour afficher tous les produits de la sous catégories
require 'open-uri'
require 'nokogiri'
require 'pry'


products = {
  velo: {
    nom: "vélo toto",
    prix: "150"
  },
  ballon: {
    nom: "vuvuzela",
    prix:"15"
  },
  toupie: {
    nom: "kyle",
    prix: "7"
  }
}


products.each do |key, value|
  puts key
  puts value
end

doc = Nokogiri::HTML(open("https://www.madine-france.com/fr/"))

filepath  = 'products.xml'
  builder   = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
    xml.root {
      xml.products {
        products.each do |key, value|
          xml.object {
            xml.category key
            xml.nom value[:nom]
          }
        end
      }
    }
  end

File.open(filepath, 'wb') { |file| file.write(builder.to_xml) }

