Rails.application.routes.draw do

  mount QuickSearch::Engine => "/"

  root :to => 'quick_search/search#index'
end
