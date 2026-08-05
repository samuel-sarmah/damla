class ContentPagesController < ApplicationController
  def show
    @content_page = ContentPage.find_by!(slug: params[:slug])
  end
end
