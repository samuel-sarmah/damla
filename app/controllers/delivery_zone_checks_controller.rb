class DeliveryZoneChecksController < ApplicationController
  def show
    @district = params[:district].presence_in(Districts::VALUES)
    @served = @district && DeliveryZone.serves?(@district)
    @map_districts = map_districts_json
  end

  private

  def map_districts_json
    served_districts = DeliveryZone.active.pluck(:district)
    Districts::VALUES.map do |code|
      lat, lng = Districts::COORDINATES.fetch(code)
      { code: code, name: t("districts.#{code}"), lat: lat, lng: lng, served: served_districts.include?(code) }
    end
  end
end
