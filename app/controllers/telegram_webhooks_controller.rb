class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  context_to_action!

  def help(*)
    respond_with :message, text: t('.content')
  end

  def pic(*args)
    image = Message.get_pic(args)
    return respond_with :message, text: image unless image.nil?
    fuckup
  end

  def mus(*args)
    song = Song.get_audio(args.join(' '))
    return fuckup if song.nil?
    respond_with :audio, audio: File.open("public/songs/#{song.filename}"),
                         caption: "#{song.author} - #{song.track}",
                         performer: song.author,
                         title: song.track
  end

  def songs(*args)
    artists = Song.where(author: args.join(' ').downcase)
                  .map { |a| [{ text: a.track, callback_data: a.id }] }
    respond_with :message, text: args.join(' ').capitalize, reply_markup: {
      inline_keyboard: artists,
      one_time_keyboard: true,
      selective: true,
    }
  end

  def art(*)
    artists = Song.select(:author).uniq.map { |a| [{ text: a.author, callback_data: a.author }] }
    respond_with :message, text: 'Исполнители:', reply_markup: {
      inline_keyboard: artists,
      one_time_keyboard: true,
      selective: true,
    }
  end

  def callback_query(data)
    return songs(data) if data.to_i.zero?
    song = Song.find(data)
    respond_with :message, text: 'Отправляю...'
    respond_with :audio, audio: File.open("public/songs/#{song.filename}"),
                         caption: "#{song.author} - #{song.track}",
                         performer: song.author,
                         title: song.track
  end

  def message(message)
    return pic(Elcin.last.zapros.split(' ')) if message['text'] == 'еще'
    Message.create!(
      zapros: ' ',
      href: ' ',
      data: update['message'],
      user_id: ' ',
      chat_id: ' ',
      username: update['message']['from']['username'],
      first_name: update['message']['from']['first_name'],
      last_name: update['message']['from']['last_name'],
      text: update['message']['text']
    )
  end

  def edited_message(message);end

  def action_missing(action, *_args)
    if command?
      respond_with :message, text: t('telegram_webhooks.action_missing.command', command: action)
    else
      respond_with :message, text: t('telegram_webhooks.action_missing.feature', action: action)
    end
  end

  def cool(*args)
    chat = -1001102168560
    bot.send_message(chat_id: chat, text: args.join(' '))
  end

  private

  def fuckup
    respond_with :message, text: 'Сорян, бро, ничего нет!'
  end
end
