class AddTimestamps < ActiveRecord::Migration
  def change
    rename_table :author, :authors

    add_timestamps(:authors, null: false)
    add_timestamps(:books, null: false)
    add_timestamps(:genres, null: false)
  end
end
