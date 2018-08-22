ThinkingSphinx::Index.define :author, with: :active_record do
  indexes first_name, as: :author_name, sortable: true
  indexes last_name, as: :author_surname, sortable: true
  indexes middle_name, as: :author_middle, sortable: true
end
