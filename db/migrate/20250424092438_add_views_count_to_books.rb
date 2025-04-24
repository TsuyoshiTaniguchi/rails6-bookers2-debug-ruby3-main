class AddViewsCountToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :views_count, :integer
  end
end
