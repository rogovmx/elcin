ThinkingSphinx::Index.define :book, with: :active_record do
  indexes title, sortable: true

  has author_id
end
