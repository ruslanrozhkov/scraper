class Scrape
  attr_accessor :title, :hotness, :image_url, :rating, :director, :genre, :release_date, :runtime, :synopsis, :failure

  def scrape_new_movie(url)
    begin
      doc = Nokogiri::HTML(open(url))
      doc.css('script').remove
      self.title = doc.at("//h1[@data-type = 'title']").text.strip
      self.hotness = doc.css('a#tomato_meter_link').css('span.meter-value')[0].text.to_i
      self.image_url = doc.at_css('img.posterImage')['src']
      self.synopsis = doc.css('div#movieSynopsis').text.strip

      i = 0
      while i < 8
        label = doc.css('div.meta-label')[i].text.chop
        case label
          when "Rating:"
            self.rating = doc.css('li.meta-row').css('div.meta-value')[i].text.strip
          when "Genre:"
            self.genre = doc.css('li.meta-row').css('div.meta-value')[i].text.strip
          when "Directed By:"
            self.director = doc.css('li.meta-row').css('div.meta-value')[i].text.strip
          when "In Theaters:"
            self.release_date = doc.css('li.meta-row').css('div.meta-value')[i].text.to_date
          when "Runtime:"
            self.runtime = doc.css('li.meta-row').css('div.meta-value')[i].text.strip
        end
        i += 1
      end
      return true
    rescue Exception => e
      self.failure = 'Something went wrong with the scrape'
    end
  end
end