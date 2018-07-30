Rails.application.routes.draw do
  root to: 'makers#index'

  get 'makers/index'
  get 'makers' => 'makers#index'

  get 'makers/calc'
  post 'makers/calc'

  get 'makers/res'
  post 'makers/res'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
