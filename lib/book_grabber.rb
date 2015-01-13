require "chronic"
require "nokogiri"
require "open-uri"

class BookGrabber
  def self.to_read(user_id = 12680)
    ["to-read", "currently-reading", "read"].each do |shelf|
      # https://www.goodreads.com/api#reviews.list
      url = "https://www.goodreads.com/review/list?format=xml&v=2&id=#{user_id}&key=AtaRYksgV1LDWkg2dTOg&per_page=200&shelf=#{shelf}"
      uri = URI.parse url
      document = Nokogiri::XML(uri.read.split("\n").map {|l| l.strip }.join '')
      document.xpath("//review").each do |book|
        title = book.at_xpath("book/title").text
        id = book.at_xpath("book/id").text.to_i

        # I think this will only ever return one author...
        authors = book.xpath("book/authors/author/name").map {|a| a.text }
        date = Chronic.parse(book.at_xpath("date_added").text)

        puts Book.factory(id, title, authors, date, shelf)
      end
    end
  end
end
