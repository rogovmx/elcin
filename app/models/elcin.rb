class Elcin < ApplicationRecord
  require 'open-uri'
  require 'net/http'
  require 'uri'
  require 'nokogiri'

  def tests(message)
    message
  end

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

    if doc.css('.dl').nil? && doc.css('.dl')[1]['href'].empty? && doc.css('.dl')[2]['href'].empty?
      return nil
    end

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
end
