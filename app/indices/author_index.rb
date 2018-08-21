ThinkingSphinx::Index.define :author, with: :active_record do
  indexes first_name
  indexes last_name, sortable: :true
  indexes middle_name
  indexes search_name
end
