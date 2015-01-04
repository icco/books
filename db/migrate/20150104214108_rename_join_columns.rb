class RenameJoinColumns < ActiveRecord::Migration
  def change
    change_table :books_genres do |t|
      t.rename :genres_id, :genre_id
      t.rename :books_id, :book_id
    end

    change_table :authors_books do |t|
      t.rename :authors_id, :author_id
      t.rename :books_id, :book_id
    end
  end
end
