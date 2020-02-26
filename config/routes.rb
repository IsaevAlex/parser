Rails.application.routes.draw do
  get 'searches/index'

  get 'searches/show'

  root 'news#index'

  resources :news do
    get :set_state, on: :collection
  end

  get 'economics' => "news#economics"
  get 'politics' => "news#politics"
  get 'state' => "news#state"
  get 'culture' => "news#culture"
  get 'science' => "news#science"
  get 'sport' => "news#sport"
  get 'football' => "news#football"
  get 'basketball' => "news#basketball"
  get 'hockey' => "news#hockey"
  get 'fight' => "news#fight"
  get 'society' => "news#society"
  get 'search' => "searches#search"
end
