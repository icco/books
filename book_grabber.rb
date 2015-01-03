require "open-uri"
require "nokogiri"

class BookGrabber
  def self.to_read(user_id = 12680)
    # https://www.goodreads.com/api#reviews.list
    url = "https://www.goodreads.com/review/list?format=xml&v=2&id=#{user_id}&key=AtaRYksgV1LDWkg2dTOg&per_page=200&shelf=to_read"
    uri = URI.parse url
    document = Nokogiri::XML(uri.read.split("\n").map {|l| l.strip }.join '')
    titles = document.xpath("//book/title").map {|t| t.content }
    ids = document.xpath("//book/id").map {|t| t.content }
  end
end
