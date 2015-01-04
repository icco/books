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
    # Example: https://www.goodreads.com/book/show/50?format=xml&key=AtaRYksgV1LDWkg2dTOg
    url = "https://www.goodreads.com/book/show/#{id}?format=xml&key=AtaRYksgV1LDWkg2dTOg"
    uri = URI.parse url
    document = Nokogiri::XML(uri.read.split("\n").map {|l| l.strip }.join '')

    @genres = document.xpath("//shelf/@name").map {|g| g.value }.delete_if {|g| /read|fav|kindle|book-club|club|series|school/.match g }
    @image = document.at_xpath("//image_url").text

    year = document.at_xpath("//book/publication_year").text.to_i
    day = document.at_xpath("//book/publication_day").text.to_i
    month = document.at_xpath("//book/publication_month").text.to_i
    begin
      @pub_date = Date.new(year,month,day)
    rescue
      puts "#{year}-#{month}-#{day} is not a valid pub date."
      @pub_date = nil
    end
  end

  def to_s
    "#{id}: #{title.inspect} by #{author} (added #{date})\n\tGenres: #{@genres}\n\tImage: #{@image}\n\tPublication Date: #{@pub_date}"
  end
end
