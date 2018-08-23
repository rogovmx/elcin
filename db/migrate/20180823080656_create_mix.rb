class CreateMix < ActiveRecord::Migration[5.0]
  def change
    create_table :mixes do |t|
      t.string :author_name, null: false
      t.string :book_title, null: false
      t.string :search_field, null: false
    end

    File.open(Rails.root.join('public', 'Author_List.csv'), "r").each_line do |line|
      data = line.split(';')

      author = Author.find(data[0].to_i)
      book = Book.find(data[1].to_i)

      Mix.create!(author_name: author.search_name.strip.downcase, book_title: book.title.strip.downcase, search_field: "#{author.search_name.strip.downcase} - #{book.title.strip.downcase}")
    end
  end
end
