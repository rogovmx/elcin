class CreateElcin < ActiveRecord::Migration[5.0]
  def change
    create_table :elcins do |t|
      t.string :zapros
      t.timestamps
    end
  end
end
