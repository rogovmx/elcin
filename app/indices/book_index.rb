ThinkingSphinx::Index.define :book, with: :active_record do
  indexes title, sortable: true
  indexes author.search_name, :as => :author, :sortable => true

  has author_id
end
