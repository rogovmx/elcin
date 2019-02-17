class AddSeriesToBook < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :series, :integer
  end
end
