require "open-uri"
require "oga"

class BookGrabber
  def self.to_read(user_id = 12680)
    # https://www.goodreads.com/api#reviews.list
    url = "https://www.goodreads.com/review/list?format=xml&v=2&id=#{user_id}&key=AtaRYksgV1LDWkg2dTOg&per_page=200&shelf=to_read"
    uri = URI.parse url
    uri.open do |file|
      body = file.read
      p body
      p file.meta
      document = Oga.parse_html(body)
      p document
    end
  end
end
