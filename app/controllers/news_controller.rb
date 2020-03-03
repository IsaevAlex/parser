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
    @search = params[:search]
    if @search.present?
      @news = New.paginate(:page => params[:page], :per_page => 10).where("category = 'Лента'").where("title LIKE ?", "%#{@search}%").order(created_at: :asc)
      if @news.present?
        @news
      else
        @text = "К сожалению нет результатов поиска"
      end
    else
      @news = New.paginate(:page => params[:page], :per_page => 10).where("category = 'Лента'").order(created_at: :desc)
    end
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
    @search = params[:search]
    if @search.present?
      @news = New.where("category = '#{$getState.value}'").where("title LIKE ?", "%#{@search}%").order(created_at: :asc).paginate(:page => params[:page], :per_page => 10)
      if @news.present?
        @news
      else
        @text = "К сожалению нет результатов поиска"
      end
    else
      @news = New.where("category = '#{$getState.value}'").order(created_at: :asc).paginate(:page => params[:page], :per_page => 10)
    end

  end

  def football
    getNewsFromRia("https://ria.ru/football/")
    if @search.present?
      @news = New.where("category = 'Футбол'").where("title LIKE ?", "%#{@search}%").order(created_at: :asc).paginate(:page => params[:page], :per_page => 10)
      if @news.present?
        @news
      else
        @text = "К сожалению нет результатов поиска"
      end
    else
      @news = New.where("category = 'Футбол'").order(created_at: :asc).paginate(:page => params[:page], :per_page => 10)
    end

  end

  def society
    getNewsFromRia("https://ria.ru/society/")
    if @search.present?
      @news = New.where("category = 'Общество'").where("title LIKE ?", "%#{@search}%").order(created_at: :asc).paginate(:page => params[:page], :per_page => 10)
      if @news.present?
        @news
      else
        @text = "К сожалению нет результатов поиска"
      end
    else
      @news = New.where("category = 'Общество'").order(created_at: :asc).paginate(:page => params[:page], :per_page => 10)
    end
  end

  def fight
    getNewsFromRia("https://ria.ru/fights/")
    if @search.present?
      @news = New.where("category = 'Единоборства'").where("title LIKE ?", "%#{@search}%").order(created_at: :asc).paginate(:page => params[:page], :per_page => 10)
      if @news.present?
        @news
      else
        @text = "К сожалению нет результатов поиска"
      end
    else
      @news = New.where("category = 'Единоборства'").order(created_at: :asc).paginate(:page => params[:page], :per_page => 10)
    end

  end

  def hockey
    getNewsFromRia("https://ria.ru/hockey/")
    if @search.present?
      @news = New.where("category = 'Хоккей'").where("title LIKE ?", "%#{@search}%").order(created_at: :asc).paginate(:page => params[:page], :per_page => 10)
      if @news.present?
        @news
      else
        @text = "К сожалению нет результатов поиска"
      end
    else
      @news = New.where("category = 'Хоккей'").order(created_at: :asc).paginate(:page => params[:page], :per_page => 10)
    end
  end

  def basketball
    getNewsFromRia("https://ria.ru/basketball/")
    if @search.present?
      @news = New.where("category = 'Баскетбол'").where("title LIKE ?", "%#{@search}%").order(created_at: :asc).paginate(:page => params[:page], :per_page => 10)
      if @news.present?
        @news
      else
        @text = "К сожалению нет результатов поиска"
      end
    else
      @news = New.where("category = 'Баскетбол'").order(created_at: :asc).paginate(:page => params[:page], :per_page => 10)
    end
  end

  def sport
    getSportNewsFromRia("https://rsport.ria.ru/")
    if @search.present?
      @news = New.where("category = 'Спорт'").where("title LIKE ?", "%#{@search}%").order(created_at: :asc).paginate(:page => params[:page], :per_page => 10)
      if @news.present?
        @news
      else
        @text = "К сожалению нет результатов поиска"
      end
    else
      @news = New.where("category = 'Cпорт'").order(created_at: :asc).paginate(:page => params[:page], :per_page => 10)
    end
  end

  def economics
    getNewsFromRia("https://ria.ru/economy/")
    if @search.present?
      @news = New.where("category = 'Экономика'").where("title LIKE ?", "%#{@search}%").order(created_at: :asc).paginate(:page => params[:page], :per_page => 10)
      if @news.present?
        @news
      else
        @text = "К сожалению нет результатов поиска"
      end
    else
      @news = New.where("category = 'Экономика'").order(created_at: :asc).paginate(:page => params[:page], :per_page => 10)
    end
  end

  def getSportNewsFromRia(url)
    doc = Nokogiri::HTML(open(url))
    entries = doc.css('.cell-list__item').take(20)
    entries.each do |entry|
      title = entry.css('.list-item__title').text
      @new = New.where(title: title).first_or_create(
          date: entry.css('.list-item__date').text,
          title: title,
          imgsrc: entry.css('.responsive_img').attr('src'),
          link: entry.css('.list-item__title').attr('href')
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
      title = entry.css('.list-item__title').text
      @new = New.where(title: title).first_or_create(
          date: entry.css('.list-item__date').text,
          title: title,
          imgsrc: entry.css('.responsive_img').attr('src'),
          link: entry.css('.list-item__title').attr('href')
      )
      @new.category = doc.css('.tag-input__tag-text').text
      @new.domain = "https://ria.ru/"
      @new.save
    end
  end

  def politics
    getNewsFromRia("https://ria.ru/politics/")
    if @search.present?
      @news = New.where("category = 'Политика'").where("title LIKE ?", "%#{@search}%").order(created_at: :asc).paginate(:page => params[:page], :per_page => 10)
      if @news.present?
        @news
      else
        @text = "К сожалению нет результатов поиска"
      end
    else
      @news = New.where("category = 'Политика'").order(created_at: :asc).paginate(:page => params[:page], :per_page => 10)
    end

  end

  def culture
    getAnotherLentaFromRia("https://ria.ru/culture/")
    if @search.present?
      @news = New.where("category = 'Культура'").where("title LIKE ?", "%#{@search}%").order(created_at: :asc).paginate(:page => params[:page], :per_page => 10)
      if @news.present?
        @news
      else
        @text = "К сожалению нет результатов поиска"
      end
    else
      @news = New.where("category = 'Культура'").order(created_at: :asc).paginate(:page => params[:page], :per_page => 10)
    end
  end

  def science
    getAnotherLentaFromRia("https://ria.ru/science/")
    if @search.present?
      @news = New.where("category = 'РИА Наука'").where("title LIKE ?", "%#{@search}%").order(created_at: :asc).paginate(:page => params[:page], :per_page => 10)
      if @news.present?
        @news
      else
        @text = "К сожалению нет результатов поиска"
      end
    else
      @news = New.where("category = 'РИА Наука'").order(created_at: :asc).paginate(:page => params[:page], :per_page => 10)
    end
  end

  def getAnotherLentaFromRia(url)
    doc = Nokogiri::HTML(open(url))
    entries = doc.css('.list-item').take(20)
    entries.each do |entry|
      title = entry.css('.list-item__title').text
      @new = New.where(title: title).first_or_create(
          date: entry.css('.list-item__date').text,
          title: title,
          imgsrc: entry.css('.responsive_img').attr('src'),
          link: entry.css('.list-item__title').attr('href')
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
      title = entry.css('.list-item__title').text
      @new = New.where(title: title).first_or_create(
          date: entry.css('.list-item__date').text,
          title: title,
          imgsrc: entry.css('.responsive_img').attr('src'),
          link: entry.css('.list-item__title').attr('href')
      )
      @new.category = 'Лента'
      @new.domain = "https://ria.ru/"
      @new.save

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
