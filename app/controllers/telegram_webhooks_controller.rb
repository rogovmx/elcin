class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  context_to_action!

  before_action :new_elcin, only: %i[test pic mus message]

  def help(*)
    respond_with :message, text: t('.content')
  end

  def test(message)
    aaa = @elcin.tests(message)
    respond_with :message, text: aaa
  end

  def pic(*args)
    Elcin.create!(zapros: args)
    source = @elcin.search_pic(args)
    return fuckup if source.nil?
    respond_with :message, text: source
  end

  def mus(*args)
    song = @elcin.get_audio(args.join(' '))
    return fuckup if song.nil?
    respond_with :audio, audio: song, performer: @artist, title: @track
  end

  def message(message)
    pic(Elcin.last.zapros) if message["text"] == "еще"
  end

  def edited_message(message);end

  def action_missing(action, *_args)
    if command?
      respond_with :message, text: t('telegram_webhooks.action_missing.command', command: action)
    else
      respond_with :message, text: t('telegram_webhooks.action_missing.feature', action: action)
    end
  end

  private

  def fuckup
    respond_with :message, text: 'Сорян, бро, ничего нет!'
  end

  def new_elcin
    @elcin = Elcin.new
  end
end
