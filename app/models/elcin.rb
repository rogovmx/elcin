class Elcin < ApplicationRecord
  def tests(message)
    respond_with :message, text: t('.content', text: message['text'])
  end
end
