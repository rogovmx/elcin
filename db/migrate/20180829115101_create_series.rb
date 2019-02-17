class CreateSeries < ActiveRecord::Migration[5.0]
  def change
    create_table :series do |t|
      t.belongs_to :author, index: true
      t.string :title
    end

    add_reference :books, :series, index: true
    add_column :books, :series_title, :string
  end
end
