class Product
  def initialize(subcategory, title, link)
    @subcategory = subcategory
    @title = title
    @link = link
  end
  attr_accessor :subcategory, :title, :link
end
