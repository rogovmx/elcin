module Message::Contract
  class Create < Reform::Form

    property :zapros
    property :href
    property :data
    property :user_id
    property :chat_id
    property :username
    property :first_name
    property :last_name
    property :text

    validates :zapros,     presence: true
    validates :href,       presence: true
    validates :data,       presence: true
    validates :user_id,    presence: true
    validates :chat_id,    presence: true
    validates :username,   presence: true
    validates :first_name, presence: true
    validates :last_name,  presence: true
    validates :text,       presence: true
  end
end
