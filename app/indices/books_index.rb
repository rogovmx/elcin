ThinkingSphinx::Index.define :book, with: :active_record do
  indexes title, sortable: true
  indexes author.first_name, as: :author_name, sortable: true
  indexes author.last_name, as: :author_surname, sortable: true
  indexes author.middle_name, as: :author_middle, sortable: true

  has author_id
end
