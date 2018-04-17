class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  context_to_action!

  NAMES = %w[бн борис борька николаевич беня борян бюря ельцин борюсик].freeze
  FUCK = %w[козлина долбоеб мудак уебок дебил идиот кретин казлина колдырь уебан придурок
            дурак дятел долбоящер долбоклюй алкаш алкоголик жопонюх хуеплет хуй козел
            гандон мудараст хуепутало пиздолиз говно дубина].freeze
  FUCK2 = %w[хуйня пидовка жопа сука скотина скотобаза срань пиздень педовка срань слякоть
             слизь сосалка блядина гнида].freeze

  FUCK_LIKE = %w[обоссаный бухой тупой уродливый ебучий калечный конченый ссаный].freeze
  FUCK_LIKE2 = %w[обоссаная бухая тупая уродливая ебучая калечная конченая ссаная].freeze

  GOOD = %w[нормальный хороший умный отличный классный поумнел вписывается подходит шарит
            врубается крутой клевый сечет норм крут четкий молоток].freeze

  GOOD_REPL = ['слышу голос разума', 'спасибо дружище', 'хоть кто-то тут нормальный',
               'а я в тебе уже сомневаться начал', 'наконец-то вы это поняли', 'ты тоже норм',
               'а ты думал', 'я нормальнее многих в этом чате'].freeze

  FUCK_REPLY = ['Слыш', 'Эй', 'Эй ты', 'Детка', 'Эээ', 'Знаешь', 'Слышишь',
                'Я че сказать хочу'].freeze

  FUCK_REPLY2 = ['Сам ты', 'От', 'Эй ты', 'Детка', 'Эээ', 'Знаешь', 'Слышишь',
  'Я че сказать хочу'].freeze

  COMANDS = %w[найди скинь ищи скачай нагугли пришли покажи].freeze
  COMANDS_REPL = ['сам ищи', 'делать мне нечего', 'не буду', 'учи команды', 'я тебе не поисковик',
                  'нашли дурака', 'тарахтел я такие приколы', 'я лучше посплю'].freeze

  COMANDS2 = %w[поделись одари].freeze
  MUDROST = %w[цитатой мудростью].freeze

  COMANDS3 = %w[скажи напиши пришли скинь].freeze
  MUDROST2 = %w[цитату мудрость фразу].freeze

  FUCK_DIR = ['иди ты', 'пошел', 'иди', 'держи путь', 'отправляйся ты', 'пиздуй', 'уебывай'].freeze
  FUCK_TO = ['на хуй', 'в жопу', 'в пизду'].freeze

  QUOTES = ['Денег мало, а любить людей нужно много.',
            'Возраст политика – 65 лет, а после этого он впадает в маразм.',
            'Просыпаясь утром, я спрашиваю себя: что ты сделал для Украины?',
            'Разве российский шоколад хуже импортного? А пиво? О водке я не говорю.',
            'Я тоже дедушка: у меня три внука. Ой, что это я, у меня четыре внука. Совсем заездился.',
            'Рожаете вы плохо. Я понимаю, сейчас трудно рожать, но все-таки надо постепенно поднатужиться.',
            'Виктор Степанович Черномырдин большую жизнь прожил, побывал и сверху, и снизу, и снизу, и сверху.',
            'Мы, конечно, все что можно со своей стороны делаем, но не все мы можем. То есть мы можем, но совесть нам не позволяет.',
            'Я бросил монетку в Енисей, на счастье. Но не думайте, что на этом финансовая поддержка вашего края со стороны президента закончена.',
            'Хорошая водичка Нарзан, вкусная. Вкусная и полезная. Но лечить мне нечего, у меня все в порядке. Но для профилактики, для омоложения - мне надо об омоложении думать. Все-таки уже 71 год',
            'Ну посмотрите, России просто не везет. Петр I не закончил реформу, Екатерина II не закончила реформу, Александр II не закончил реформу, Столыпин не закончил реформу. Я должен закончить реформу.',
            'Наша страна стоит на краю пропасти, но благодаря Президенту мы сделаем шаг вперед!',
            'Вот берёшь нашу картошку в руки… А она вся такая… Рассыпчатая',
            'Как тот такой же, так и этот, понимаешь. Два генерала... ',
            'Мы с Колем встречались трижды. Вот такая мужская любовь.',
            'Пятьдесят наименований микроэлементов в одной корове, вот поэтому она и даёт.',
            'Самое главное, чтобы у меня чемоданчик мой не свистнули.',
            'У меня давление всегда нормальное, 120 на 80. Хоть ночью меня разбуди, хоть во время заседания, хоть во время стресса — всегда 120 на 80.'].freeze

  PLINTUS = ['Нельзя просто так взять и присверлить плинтус, точнее можно, но не просто так!',
             'Да кому нужны плинтуса сегодня? Все это глупости.',
             'Как-то приходит ко мне на совещание Черномырдин, а у него из кормана плинтус торчит.',
             'Наина, бывало, как скажет: Боря, твою медь, прибей уже этот сраный плинтус!'].freeze
  SVERLO =  ['Я, когда был молодым, имел до 15-и сверел в наборе.',
             'Бывало, купишь сверло, бежишь домой, пробовать сейчас будешь. Открываешь пакет, а оно(сверло) хуяк, и гусь! Вот что с ним делать?',
             'Я однажды высверлил вооооот такую розетку!',
             'Если бы не сверла, я может быть и не женился бы никогда!',
             'Советские сверла были самыми сверластыми. Гладкие уже все, а сверлят!',
             'Бывало намотаешь БФ-а на свело и счастлив!'].freeze
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
    respond_with :message, text: 'Сорян, музыки пока не будет.'
    # song = Song.get_audio(args.join(' '))
    # return fuckup if song.nil?
    # respond_with :audio, audio: File.open("public/songs/#{song.filename}"),
    #                      caption: "#{song.author} - #{song.track}",
    #                      performer: song.author,
    #                      title: song.track
  end

  def songs(*args)
    respond_with :message, text: 'Сорян, музыки пока не будет.'
    # artists = Song.where(author: args.join(' ').downcase)
    #               .map { |a| [{ text: a.track, callback_data: a.id }] }
    # respond_with :message, text: args.join(' ').capitalize, reply_markup: {
    #   inline_keyboard: artists,
    #   one_time_keyboard: true,
    #   selective: true,
    # }
  end

  def art(*)
    respond_with :message, text: 'Сорян, музыки пока не будет.'
    # artists = Song.select(:author).uniq.map { |a| [{ text: a.author, callback_data: a.author }] }
    # respond_with :message, text: 'Исполнители:', reply_markup: {
    #   inline_keyboard: artists,
    #   one_time_keyboard: true,
    #   selective: true,
    # }
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
    words = message['text']&.downcase&.gsub(/[!?.,"\/\\]/, ' ')&.split(' ')
    unless words.nil?
      unless (words & ['сверло', 'сверла', 'сверел', 'сверлом', 'сверл', 'сверлах', 'свёрла', 'свёрел', 'свёрл', 'свёрлах']).empty?
        sleep 5
        respond_with :message, text: SVERLO[rand(0..(SVERLO.size-1))]
      end
      unless (words & ['плинтус', 'плинтуса', 'плинтусом', 'плинтусами', 'плинтусов', 'плинтусах']).empty?
        sleep 5
        respond_with :message, text: PLINTUS[rand(0..(PLINTUS.size-1))]
      end
      unless (words & NAMES).empty?
        (words & NAMES).map { |w| words.delete(w) }
        govorilka(words)
      end
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
    sleep 2
    if (words & FUCK).size.nonzero? || (words & FUCK2).size.nonzero? || (words & FUCK_LIKE).size.nonzero? || (words & FUCK_LIKE2).size.nonzero?
      fuck = words & FUCK if (words & FUCK).size.nonzero?
      fuck_like = words & FUCK_LIKE if (words & FUCK_LIKE).size.nonzero?
      fuck2 = words & FUCK2 if (words & FUCK2).size.nonzero?
      fuck_like2 = words & FUCK_LIKE2 if (words & FUCK_LIKE2).size.nonzero?
      otvet = "#{FUCK_REPLY[rand(0..FUCK_REPLY.size-1)]}, #{FUCK[rand(0..FUCK.size-1)]} #{FUCK_LIKE[rand(0..FUCK_LIKE.size-1)]}, #{FUCK_DIR[rand(0..FUCK_DIR.size-1)]} #{FUCK_TO[rand(0..FUCK_TO.size-1)]}, #{FUCK[rand(0..FUCK.size-1)]} #{FUCK_LIKE[rand(0..FUCK_LIKE.size-1)]}!"
      otvet2 = "#{FUCK_REPLY[rand(0..FUCK_REPLY.size-1)]}, #{FUCK2[rand(0..FUCK2.size-1)]} #{FUCK_LIKE2[rand(0..FUCK_LIKE2.size-1)]}, #{FUCK_DIR[rand(0..FUCK_DIR.size-1)]} #{FUCK_TO[rand(0..FUCK_TO.size-1)]}, #{FUCK2[rand(0..FUCK2.size-1)]} #{FUCK_LIKE2[rand(0..FUCK_LIKE2.size-1)]}!"
      otvet3 = "Сам ты #{fuck_like&.join(', ')} #{fuck&.join(', ')}!" if (words & FUCK_LIKE).size.nonzero?
      otvet4 = "Сам ты #{fuck_like2&.join(', ')} #{fuck2&.join(', ')}!" if (words & FUCK_LIKE2).size.nonzero?
      otvets = [otvet, otvet2, otvet3, otvet4]
      respond_with :message, text: otvets[rand(0..otvets.compact.size-1)]
    elsif (words & COMANDS2).size.nonzero? && (words & MUDROST).size.nonzero? || (words & COMANDS3).size.nonzero? && (words & MUDROST2).size.nonzero?
      respond_with :message, text: QUOTES[rand(0..QUOTES.size-1)]
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
