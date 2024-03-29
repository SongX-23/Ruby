require 'date'
require 'rss'
require 'open-uri'
require_relative 'news.rb'
require_relative 'article_ABC.rb'

#   This class is inherited from the Importer. It requires the native library 
# 'date', 'open-uri'and 'rss'.
#
#   This class is responsible for importing the articles from ABC. 
#
#   url is the address of the top sports news from ABC news source.
#
#   self.source_name return the name of this source.
#
#   scrape method performs an rss parsing and getting the information from it.

# Created by Song Xue (667692)
# Engineering and IT school, University of Melbourne

class Importer_RSS2 < News::Importer
  def initialize(start_date, end_date)
    super
    url = 'http://www.abc.net.au/sport/syndicate/sport_all.xml'
    rss = open(url).read
    @feed = RSS::Parser.parse(rss,false)
    @source = @feed.channel.title.to_s
  end

  # RETURN THE SOURCE NAME
  def self.source_name
    'ABC'
  end
  # PERFORM SCRAPE AND STORE THE ARTICLES
  def scrape
    # CODE HERE

    @feed.items.each do |item|
      #set different items to article object
      #how to get author, image ?
      article = Article_ABC.new 'Blank',
                                      item.title.delete(','),
                                      item.description.to_s.delete(','),
                                      'Blank',
                                      @source,
                                      item.pubDate.to_s.delete(','),
                                      item.link
      @articles << article
    end
    # PRINT OUT THE BRIEF INFO FOR DEBUGGING USE
    @articles.each do |article|
      puts "Successfully scraped one article:\nTitle:#{article.title}\n"
    end
  end
end