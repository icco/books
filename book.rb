class Book
  attr_accessor :id, :title, :author, :date

  def self.factory(id, title, author, date)
    b = Book.new
    b.id = id
    b.title = title
    b.author = author
    b.date = date

    b.fetch_data

    return b
  end

  def fetch_data
    url = "https://www.goodreads.com/book/show/#{id}?format=xml&key=AtaRYksgV1LDWkg2dTOg"
    uri = URI.parse url
    document = Nokogiri::XML(uri.read.split("\n").map {|l| l.strip }.join '')
    @genres = document.xpath("//shelf/@name").map {|g| g.value }.delete_if {|g| /read|fav|kindle|book-club|club|series|school/.match g }
  end

  def to_s
    "#{id}: #{title.inspect} by #{author} (added #{date}) {Genres #{@genres}}"
  end
end
