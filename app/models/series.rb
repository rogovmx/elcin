class Series < ApplicationRecord
  has_many :books
  belongs_to :author
end
