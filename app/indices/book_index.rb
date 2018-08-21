ThinkingSphinx::Index.define :book, with: :real_time do
  indexes title, sortable: true
  indexes author.search_name, :as => :author, :sortable => true

  has author_id
end
