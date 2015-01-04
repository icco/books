require "nokogiri"
require "open-uri"

class Book < ActiveRecord::Base
  has_many :authors
  has_many :genres
  validates :title, :presence => true

  def self.factory(id, title, authors, date)
    b = Book.where(id: id).first_or_create do |b|
      b.title = title
      b.date_added = date
      b.authors = authors.map do |a|
        Author.where(name: a).first_or_create
      end
      b.fetch_data
    end

    return b
  end

  # Gets genres, images and dates.
  def fetch_data
    # Example: https://www.goodreads.com/book/show/50?format=xml&key=AtaRYksgV1LDWkg2dTOg
    url = "https://www.goodreads.com/book/show/#{id}?format=xml&key=AtaRYksgV1LDWkg2dTOg"
    uri = URI.parse url
    document = Nokogiri::XML(uri.read.split("\n").map {|l| l.strip }.join '')

    self.genres = document.xpath("//shelf/@name").map {|g| g.value }.delete_if {|g| /read|fav|kindle|book-club|club|series|school/.match g }.map do |g|
      Genre.where(name: g).first_or_create
    end
    self.image_url = document.at_xpath("//image_url").text

    # TODO(icco): Support a wider variety of granularity (for instance if the
    # pub date is just a year.
    begin
      year = document.at_xpath("//book/publication_year").text.to_i
      day = document.at_xpath("//book/publication_day").text.to_i
      month = document.at_xpath("//book/publication_month").text.to_i
      self.pub_date = Date.new(year,month,day)
    rescue
      puts "#{year}-#{month}-#{day} is not a valid pub date."
      self.pub_date = nil
    end
  end

  def to_s
    "#{id}: #{title.inspect} by #{authors} (added #{date})\n\tGenres: #{genres}\n\tImage: #{image_url}\n\tPublication Date: #{pub_date}"
  end
end
