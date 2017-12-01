class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  context_to_action!

  NAMES = %w[бн борис борька николаевич беня борян бюря ельцин].freeze
  FUCK = %w[козлина долбоеб мудак уебок дебил идиот кретин казлина падла колдырь уебан придурок
            дурак дятел долбоящер долбоклюй алкаш алкоголик жопа жопонюх хуеплет хуй хуйня козел
            гнида сука скотина скотобаза мудараст хуепутало].freeze
  FUCK_LIKE = %w[обоссаный бухой тупой уродливый ебучий калечный конченый].freeze

  FUCK_REPLY = ['Слыш', 'Эй', 'Эй ты', 'Детка', 'Эээ', 'Знаешь', 'Слышишь',
                'Я че сказать хочу'].freeze
  FUCK_DIR = ['иди ты', 'пошел', 'иди', 'держи путь', 'отправляйся ты', 'пиздуй', 'уебывай'].freeze
  FUCK_TO = ['на хуй', 'в жопу', 'в пизду'].freeze

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
    return pic(Message.last.zapros.split(' ')) if message['text'] == 'еще'
    words = message['text'].downcase.gsub(/[!?.,"\/\\]/, ' ').split(' ')
    if (words & NAMES).size.nonzero?
      govorilka(words)
    end
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

  def govorilka(words)
    if (words & FUCK).size.nonzero? || (words & FUCK_LIKE).size.nonzero?
      otvet = "#{FUCK_REPLY[rand(0..FUCK_REPLY.size-1)]}, #{FUCK[rand(0..FUCK.size-1)]} #{FUCK_LIKE[rand(0..FUCK_LIKE.size-1)]}, #{FUCK_DIR[rand(0..FUCK_DIR.size-1)]} #{FUCK_TO[rand(0..FUCK_TO.size-1)]}, #{FUCK[rand(0..FUCK.size-1)]} #{FUCK_LIKE[rand(0..FUCK_LIKE.size-1)]}!"
      respond_with :message, text: otvet
    end
  end
end
