module QuickSearch
  class PagesController < ApplicationController

    include Auth

    before_action :auth, only: [:realtime]

    def home
    end

    def about
    end

    def realtime
    end

  end
end
