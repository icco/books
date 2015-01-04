class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.text :title
      t.datetime :date_added
      t.datetime :pub_date
      t.string :image_url
    end

    create_table :genres do |t|
      t.string :name
    end

    create_table :author do |t|
      t.string :name
    end

    create_table :books_genres, :id => false do |t|
      t.references :books
      t.references :genres
    end

    create_table :books_authors, :id => false do |t|
      t.references :books
      t.references :authors
    end
  end
end
