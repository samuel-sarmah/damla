class ProductsController < ApplicationController
  def index
    @products = Product.active.ordered
  end

  def show
    @product = Product.active.find(params[:id])
  end
end
