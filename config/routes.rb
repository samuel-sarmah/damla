Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root to: redirect("/tr")

  # Required (not optional) locale segment: every public URL is unambiguous and
  # crawlable per-language, which matters once :el/:ru are added later.
  scope "/:locale", locale: /tr|en/ do
    get "/", to: "home#index", as: :locale_root
    resources :products, only: [:index, :show]
    get "delivery-check", to: "delivery_zone_checks#show", as: :delivery_zone_check
    resources :delivery_orders, only: [:new, :create]
    resources :content_pages, only: [:show], param: :slug, path: "pages"
  end

  # Internal staff tool — not locale-scoped (see Staff::BaseController).
  namespace :staff do
    resource :session
    resources :passwords, param: :token
    resources :delivery_orders
    root to: redirect("/staff/delivery_orders")
  end
end
