class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

   class Currency
      def initialize(title,value)
        @title = title
        @value = value
      end
      attr_reader :title
      attr_reader :value
   end

  class Weather
    def initialize(title,value)
      @title = title
      @value = value
    end
    attr_reader :title
    attr_reader :value
  end

  def linkInclude(domain, link)
    if link.include? "ria.ru"
      return url = link
    else
      return url = domain + link
    end
  end



end
