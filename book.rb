class Book
  attr_accessor :id, :title, :author, :date

  def self.factory(id, title, author, date)
    b = Book.new
    b.id = id
    b.title = title
    b.author = author
    b.date = date
    return b
  end

  def to_s
    "#{id}: #{title.inspect} by #{author} (added #{date})"
  end
end
