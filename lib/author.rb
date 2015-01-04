class Author < ActiveRecord::Base
  belongs_to_many :books
  validates :name, :presence => true, uniqueness: true
end
