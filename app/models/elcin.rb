class Elcin < ApplicationRecord
  def answer(message)
    respond_with :message, text: t('.content', text: message['text'])
  end
end
