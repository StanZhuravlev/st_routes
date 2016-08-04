Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root :to => "mainpage#mainpage"

  # Эта строка должна быть последней
  get "*path", to: StRoutes::RecognizeRoute.new

end
