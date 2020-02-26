class SearchesController < ApplicationController
  require 'addressable/uri'
  def searchNews(url)
    doc = Nokogiri::HTML(open(url))
    entries = doc.css('.list-item').take(20)
    entries.each do |entry|
      @search = Search.create!(
          date: entry.css('.list-item__date').text ,
          title: entry.css('.list-item__title').text,
          link: entry.css('.list-item__title').attr('href'),
          imgsrc: entry.css('.responsive_img').attr('src')
      )
      @search.domain = "https://ria.ru/"
      @search.save
    end
  end

  def search
    url_string = params[:search].gsub(' ','%20')
    url=Addressable::URI.parse(url_string)
    url=url.normalize
    searchNews("https://ria.ru/search/?query=#{url}")
    redirect_to action: 'index'
  end

  def index
    @searches = Search.order(created_at: :asc).last(20)
  end

  def show
    @search = Search.find(params[:id])
    url = linkInclude(@search.domain,@search.link)
    doc = Nokogiri::HTML(open(url))

    if (@search.imgsrc.nil?)
      @search.imgsrc = doc.css('.media__size img').attr('src')
    end

    @search.text = doc.css('.article__text').text
    @search.date = doc.css('.article__info-date').text

  end
end
