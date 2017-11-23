class TelegramWebhooksController < Telegram::Bot::UpdatesController
  require 'open-uri'
  require 'net/http'
  require 'uri'
  require 'nokogiri'
  include Telegram::Bot::UpdatesController::MessageContext
  context_to_action!

  def help(*)
    respond_with :message, text: t('.content')
  end

  def test(message)
    aaa = TelegramWebhooks.tests(message)
    respond_with :message, text: t('.content', text: aaa)
  end

  def pic(*args)
    Elcin.create!(zapros: args)
    source = search_pic(args)
    return fuckup if source.nil?
    respond_with :message, text: source
  end

  def mus(*args)
    song = get_audio(args.join(' '))
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

  def search_pic(zapros)
    images = yandex_pic(zapros)
    images = bing_pic(zapros) if images.size.zero?
    images[rand(0..images.size)] if images.size > 1
  end

  def yandex_pic(zapros)
    url = "https://yandex.ru/images/search?text=#{zapros.join('-')}&isize=medium&itype=jpg"
    stroka = URI.encode(url)
    html = Net::HTTP.get(URI.parse(stroka))
    URI.extract(html).select { |l| l[/\.(?:jpe?g)\b/] }
  end

  def bing_pic(zapros)
    url = "https://www.bing.com/images/search?q=#{zapros.join('+')}&go=Поиск"
    stroka = URI.encode(url)
    html = Net::HTTP.get(URI.parse(stroka))
    URI.extract(html).select { |l| l[/\.(?:jpe?g)\b/] }
  end

  def get_audio(poisk)
    zapros = poisk.downcase.gsub(/[!?.,"\/\\]/, ' ').split(' ')
    url = ("https://mp3poisk.info/s/#{zapros.join('-')}")

    stroka = URI.encode(url)
    html = Net::HTTP.get(URI.parse(stroka))
    doc = Nokogiri::HTML(html)

    return nil if doc.css('.dl')[1]['href'].nil? || doc.css('.dl')[2]['href'].nil?

    href = doc.css('.dl')[2]['href'] || doc.css('.dl')[1]['href']

    stroka = URI.encode(href)
    html = Net::HTTP.get(URI.parse(stroka))
    doc = Nokogiri::HTML(html)

    href = doc.css('.buttonDownload')[0]['href']

    return nil if doc.css('.buttonDownload').empty? || href.nil?

    title = doc.css('.buttonDownload')[0]['download']
    @artist = doc.css('.hide')[1].css('.artist')[0].text
    @track = doc.css('.hide')[1].css('.track')[0].text

    if !File.exist?("public/songs/#{title}")
      File.open("public/songs/#{title}", "wb") do |saved_file|
        open(href, "rb") do |read_file|
          saved_file.write(read_file.read)
        end
      end
    end
    File.open("public/songs/#{title}")
  end

  def fuckup
    respond_with :message, text: 'Сорян, бро, ничего нет!'
  end
end
