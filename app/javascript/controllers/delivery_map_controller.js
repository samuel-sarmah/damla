import { Controller } from "@hotwired/stimulus"
import L from "leaflet"

// Renders the 6 TRNC delivery districts on a free OpenStreetMap base layer.
// Clicking a marker re-runs the delivery-zone check for that district.
export default class extends Controller {
  static values = {
    districts: Array,
    selected: String,
    center: Array,
  }

  connect() {
    this.map = L.map(this.element, { scrollWheelZoom: false }).setView(this.centerValue, 9)

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
      maxZoom: 18,
    }).addTo(this.map)

    this.districtsValue.forEach((district) => {
      const isSelected = district.code === this.selectedValue
      const color = !district.served ? "#94a3b8" : isSelected ? "#0369a1" : "#059669"

      const marker = L.circleMarker([district.lat, district.lng], {
        radius: isSelected ? 12 : 9,
        color: "#ffffff",
        weight: 2,
        fillColor: color,
        fillOpacity: 0.9,
      }).addTo(this.map)

      marker.bindTooltip(`${district.name}${district.served ? "" : " (—)"}`, { direction: "top", offset: [0, -6] })
      marker.on("click", () => this.selectDistrict(district.code))
    })
  }

  selectDistrict(code) {
    const url = new URL(window.location.href)
    url.searchParams.set("district", code)
    window.location.href = url.toString()
  }

  disconnect() {
    if (this.map) {
      this.map.remove()
      this.map = null
    }
  }
}
