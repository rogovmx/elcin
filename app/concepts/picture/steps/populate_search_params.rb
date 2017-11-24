# frozen_string_literal: true

module Picture::Steps
  class PopulateSearchParams
    extend Uber::Callable

    def self.call(options, params:, **)
      options["params"] = {
        zapros: params.empty? ? nil : params[:args].join(' '),
        search: params[:args],
        data: params["message"],
        user_id: params["message"]["from"]["id"],
        chat_id: params["message"]["chat"]["id"],
        username: params["message"]["from"]["username"],
        first_name: params["message"]["from"]["first_name"],
        last_name: params["message"]["from"]["last_name"],
        text: params["message"]["text"]
      }
    end
  end
end
