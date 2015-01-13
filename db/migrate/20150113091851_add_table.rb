class AddTable < ActiveRecord::Migration
  def change
    add_column :books, :shelf, :string
  end
end
