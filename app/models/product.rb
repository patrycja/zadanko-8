class Product < ActiveRecord::Base
  #has_many :line_items
  has_many :orders, :through => :line_items
  
  validates_presence_of :name, :description, :price
  validates_numericality_of :price
end
