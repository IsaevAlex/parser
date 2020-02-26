class NewsController < ApplicationController
  # before_action :newsDestroy, only: [ :economics, :state, :culture, :science]
  require 'open-uri'

  def set_state
    $getState = State.find_by(name: params[:set_state])
    # $state = params[:set_state]
    redirect_to action: 'state'
  end

  def index
    get_currency
    get_weather
    getLentaFromRia("https://ria.ru/lenta/")
    @news = New.order(created_at: :asc).last(20)
  end

  def newsDestroy
    New.destroy_all
  end

  def show
    @new = New.find(params[:id])
    url = linkInclude(@new.domain,@new.link)
    doc = Nokogiri::HTML(open(url))

    # if(@new.domain == "https://lenta.ru/")
    #   @new.text = doc.css('.js-topic__text > p').text
    #   @new.date = doc.at('.b-topic__info > time').attr('datetime')
    #   @new.imgsrc = doc.css('.g-picture').attr('src')
    # else if (@new.domain == "https://ria.ru/")
    if (@new.imgsrc.nil?)
      @new.imgsrc = doc.css('.media__size img').attr('src')
    end

    @new.text = doc.css('.article__text').text
    @new.date = doc.css('.article__info-date').text


  end

  def state
    getNewsFromRia("https://ria.ru/#{$getState.name}/")
    @news = New.where("category = '#{$getState.value}'").order(created_at: :asc).last(20)
  end

  def football
    getNewsFromRia("https://ria.ru/football/")
    @news = New.where("category = 'Футбол'").order(created_at: :asc).last(20)
  end

  def society
    getNewsFromRia("https://ria.ru/society/")
    @news = New.where("category = 'Общество'").order(created_at: :asc).last(20)
  end

  def fight
    getNewsFromRia("https://ria.ru/fights/")
    @news = New.where("category = 'Единоборства'").order(created_at: :asc).last(20)
  end

  def hockey
    getNewsFromRia("https://ria.ru/hockey/")
    @news = New.where("category = 'Хоккей'").order(created_at: :asc).last(20)
  end

  def basketball
    getNewsFromRia("https://ria.ru/basketball/")
    @news = New.where("category = 'Баскетбол'").order(created_at: :asc).last(20)
  end

  def sport
    getSportNewsFromRia("https://rsport.ria.ru/")
    @news = New.where("category = 'Cпорт'").order(created_at: :asc).last(20)
  end

  def economics
    getNewsFromRia("https://ria.ru/economy/")
    @news = New.where("category = 'Экономика'").order(created_at: :asc).last(20)
  end

  def getSportNewsFromRia(url)
    doc = Nokogiri::HTML(open(url))
    entries = doc.css('.cell-list__item').take(20)
    entries.each do |entry|
      @new = New.create!(
          date: entry.css('.elem-info__date').text ,
          title: entry.css('.cell-list__item-title').text,
          link: entry.css('.cell-list__item-link').attr('href')
      )
      @new.category = "Cпорт"
      @new.domain = "https://ria.ru/"
      @new.save
    end
  end

  def getNewsFromRia(url)
    doc = Nokogiri::HTML(open(url))
    entries = doc.css('.list-item').take(20)
    entries.each do |entry|
      @new = New.create!(
          date: entry.css('.list-item__date').text ,
          title: entry.css('.list-item__title').text,
          link: entry.css('.list-item__title').attr('href'),
          imgsrc: entry.css('.responsive_img').attr('src')
      )
      @new.category = doc.css('.tag-input__tag-text').text
      @new.domain = "https://ria.ru/"
      @new.save
    end
  end

  def politics
    getNewsFromRia("https://ria.ru/politics/")
    @news = New.where("category = 'Политика'").order(created_at: :asc).last(20)
  end

  def culture
    getAnotherLentaFromRia("https://ria.ru/culture/")
    @news = New.where("category = 'Культура'").order(created_at: :asc).last(20)
  end

  def science
    getAnotherLentaFromRia("https://ria.ru/science/")
    @news = New.where("category = 'РИА Наука'").order(created_at: :asc).last(20)
  end

  def getAnotherLentaFromRia(url)
    doc = Nokogiri::HTML(open(url))
    entries = doc.css('.list-item').take(20)
    entries.each do |entry|
      @new = New.create!(
          date: entry.css('.list-item__date').text ,
          title: entry.css('.list-item__title').text,
          link: entry.css('.list-item__title').attr('href'),
          imgsrc: entry.css('.responsive_img').attr('src')
      )
      @new.category = doc.css('.page__media-title').text
      @new.domain = "https://ria.ru/"
      @new.save
    end
  end

  def getLentaFromRia(url)
    doc = Nokogiri::HTML(open(url))
    entries = doc.css('.list-item').take(20)
    entries.each do |entry|
      @new = New.create!(
          date: entry.css('.list-item__date').text ,
          title: entry.css('.list-item__title').text,
          link: entry.css('.list-item__title').attr('href'),
          imgsrc: entry.css('.responsive_img').attr('src')
      )
      @new.domain = "https://ria.ru/"
      @new.save
    end
  end

  def getNewsFromLentaRu
    urls = ["https://lenta.ru/rubrics/economics/",
            "https://lenta.ru/rubrics/science/",
            "https://lenta.ru/rubrics/culture/",
            "https://lenta.ru/rubrics/sport/"
    ]
    urls.each do |url|
      doc = Nokogiri::HTML(open(url))
      entries = doc.css('.titles').take(10)
      entries.each do |entry|
        @new = New.create!(
            date: entry.css('.item__date').text ,
            title: entry.css('span').text,
            link: entry.css('a')[0]['href']
        )
        @new.category = doc.css('.b-header__block').text
        @new.domain = "https://lenta.ru/"
        @new.save
      end

    end
  end

  def get_currency
    doc = Nokogiri::HTML(open("https://news.rambler.ru/"))

    @currencyArray = []
    entries = doc.css('.currency__item')
    entries.each do |entry|
      title = entry.css('.currency__item-title').text
      value = entry.css('.currency__item-info').text
      @currencyArray << Currency.new(title,value)
    end
  end

  def get_weather
    doc = Nokogiri::HTML(open("https://yandex.ru/"))

    @weatherArray = []
    title = doc.css('.weather__temp').text
    value = doc.css('weather__forecast a').text
    @weatherArray << Weather.new(title,value)
  end

    private

        def new_params
           params.require(:new).(:title, :text, :date, :link, :imgsrc)
        end
end
