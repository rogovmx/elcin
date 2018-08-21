ThinkingSphinx::Index.define :author, with: :active_record do
  indexes first_name, sortable: true
  indexes last_name
  indexes middle_name
end
