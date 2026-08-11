class HomeController < ApplicationController
  def index
    @products = Product.active.ordered
  end
end
