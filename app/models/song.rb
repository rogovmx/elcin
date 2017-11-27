class Song < ApplicationRecord
  require 'open-uri'
  require 'net/http'
  require 'uri'
  require 'nokogiri'

  class << self
    def get_audio(poisk)
      zapros = poisk.downcase.gsub(/[!?.,"\/\\]/, ' ').split(' ')
      zapros.each { |w| zapros.delete(w) if w.length == 1 }

      url = ("https://mp3poisk.info/s/#{zapros.join('-')}")

      stroka = URI.encode(url)
      html = Net::HTTP.get(URI.parse(stroka))
      doc = Nokogiri::HTML(html)

      return nil if doc.css('ul.songsListen li.item div.itemCenter div.desc a')[0]['href'].nil?

      href = doc.css('ul.songsListen li.item div.itemCenter div.desc a')[0]['href']

      stroka = URI.encode(href)
      html = Net::HTTP.get(URI.parse(stroka))
      doc = Nokogiri::HTML(html)

      href = doc.css('.buttonDownload')[0]['href']

      return nil if doc.css('.buttonDownload').empty? || href.nil?

      title = doc.css('.buttonDownload')[0]['download']
      @artist = doc.css('.hide')[1].css('.artist')[0].text
      @track = doc.css('.hide')[1].css('.track')[0].text

      song = Song.find_by(filename: title)

      if !song
        File.open("public/songs/#{title}", "wb") do |saved_file|
          open(href, "rb") do |read_file|
            saved_file.write(read_file.read)
          end
        end
        song = Song.create!(author: @artist.downcase, track: @track.downcase, filename: title.downcase, href: href)
      end
      song
    end
  end
end
