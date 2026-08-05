class DeliveryZoneChecksController < ApplicationController
  def show
    @district = params[:district].presence_in(Districts::VALUES)
    @served = @district && DeliveryZone.serves?(@district)
  end
end
