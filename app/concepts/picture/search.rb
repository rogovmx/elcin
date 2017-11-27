# frozen_string_literal: true

class Picture::Search < Trailblazer::Operation.version(2)
  step Picture::Steps::PopulateSearchParams
  step Model(Message, :new)
  step Contract::Build(constant: Message::Contract::Create)
  step :search_pic!
  step Contract::Validate()
  step Contract::Persist()

  def search_pic!(_options, model:, params:, **)
    images = Message.yandex_pic(params[:search])
    images = Message.bing_pic(params[:search]) if images.size.zero?

    params[:href] = images.size > 1 ? images[rand(0..images.size)] : nil
  end
end
