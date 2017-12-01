class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  context_to_action!

  NAMES = %w[бн борис борька николаевич беня борян бюря ельцин борюсик].freeze
  FUCK = %w[козлина долбоеб мудак уебок дебил идиот кретин казлина колдырь уебан придурок
            дурак дятел долбоящер долбоклюй алкаш алкоголик жопонюх хуеплет хуй козел
            гандон мудараст хуепутало пиздолиз].freeze
  FUCK2 = %w[хуйня пидовка жопа сука скотина скотобаза срань пиздень педовка срань слякоть
             слизь сосалка блядина гнида].freeze

  FUCK_LIKE = %w[обоссаный бухой тупой уродливый ебучий калечный конченый].freeze
  FUCK_LIKE2 = %w[обоссаная бухая тупая уродливая ебучая калечная конченая].freeze

  GOOD = %w[нормальный хороший умный отличный классный поумнел вписывается подходит шарит
            врубается крутой клевый сечет норм крут четкий].freeze

  GOOD_REPL = ['слышу голос разума', 'спасибо дружище', 'хоть кто-то тут нормальный',
               'а я в тебе уже сомневаться начал', 'наконец-то вы это поняли', 'ты тоже норм',
               'а ты думал', 'я нормальнее многих в этом чате'].freeze

  FUCK_REPLY = ['Слыш', 'Эй', 'Эй ты', 'Детка', 'Эээ', 'Знаешь', 'Слышишь',
                'Я че сказать хочу'].freeze

  COMANDS = %w[найди скинь ищи скачай нагугли пришли].freeze
  COMANDS_REPL = ['сам ищи', 'делать мне нехуй', 'не буду', 'учи команды', 'я тебе не поисковик',
                  'нашли дурака', 'ебал я в рот такие приколы', 'я лучше посплю'].freeze

  FUCK_DIR = ['иди ты', 'пошел', 'иди', 'держи путь', 'отправляйся ты', 'пиздуй', 'уебывай'].freeze
  FUCK_TO = ['на хуй', 'в жопу', 'в пизду'].freeze

  def help(*)
    respond_with :message, text: t('.content')
  end

  def pic(*args)
    image = Message.get_pic(args)
    Message.create(zapros: args.join(' '), href: image, data: "") unless image.nil?
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
    sleep 3
    if (words & FUCK).size.nonzero? || (words & FUCK2).size.nonzero? || (words & FUCK_LIKE).size.nonzero? || (words & FUCK_LIKE2).size.nonzero?
      otvet = "#{FUCK_REPLY[rand(0..FUCK_REPLY.size-1)]}, #{FUCK[rand(0..FUCK.size-1)]} #{FUCK_LIKE[rand(0..FUCK_LIKE.size-1)]}, #{FUCK_DIR[rand(0..FUCK_DIR.size-1)]} #{FUCK_TO[rand(0..FUCK_TO.size-1)]}, #{FUCK[rand(0..FUCK.size-1)]} #{FUCK_LIKE[rand(0..FUCK_LIKE.size-1)]}!"
      otvet2 = "#{FUCK_REPLY[rand(0..FUCK_REPLY.size-1)]}, #{FUCK2[rand(0..FUCK2.size-1)]} #{FUCK_LIKE2[rand(0..FUCK_LIKE2.size-1)]}, #{FUCK_DIR[rand(0..FUCK_DIR.size-1)]} #{FUCK_TO[rand(0..FUCK_TO.size-1)]}, #{FUCK2[rand(0..FUCK2.size-1)]} #{FUCK_LIKE2[rand(0..FUCK_LIKE2.size-1)]}!"
      otvets = [otvet, otvet2]
      respond_with :message, text: otvets[rand(0..1)]
    elsif (words & COMANDS).size.nonzero?
      otvet = "#{FUCK_REPLY[rand(0..FUCK_REPLY.size-1)]}, #{COMANDS_REPL[rand(0..COMANDS_REPL.size-1)]}."
      otvet2 = "#{COMANDS_REPL[rand(0..COMANDS_REPL.size-1)].capitalize}."
      otvets = [otvet, otvet2]
      respond_with :message, text: otvets[rand(0..1)]
    elsif (words & GOOD).size.nonzero?
      otvet = "#{GOOD_REPL[rand(0..GOOD_REPL.size-1)].capitalize}."
      respond_with :message, text: otvet
    end
  end
end
