import { Controller } from "@hotwired/stimulus"
import L from "leaflet"

// Lets a customer drop a pin for their delivery address. This is a supplement
// to, not a replacement for, the required free-text address description —
// TRNC addressing isn't reliably numbered/mapped, so the pin just gives the
// driver a head start.
export default class extends Controller {
  static targets = ["map", "lat", "lng", "hint"]
  static values = { center: Array }

  connect() {
    this.map = L.map(this.mapTarget, { scrollWheelZoom: false }).setView(this.centerValue, 9)

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
      maxZoom: 18,
    }).addTo(this.map)

    this.marker = null
    this.map.on("click", (e) => this.dropPin(e.latlng))
  }

  dropPin(latlng) {
    if (this.marker) {
      this.marker.setLatLng(latlng)
    } else {
      this.marker = L.marker(latlng, { draggable: true }).addTo(this.map)
      this.marker.on("dragend", () => this.setCoordinates(this.marker.getLatLng()))
    }
    this.setCoordinates(latlng)
  }

  setCoordinates(latlng) {
    this.latTarget.value = latlng.lat.toFixed(6)
    this.lngTarget.value = latlng.lng.toFixed(6)
    if (this.hasHintTarget) this.hintTarget.textContent = `${latlng.lat.toFixed(5)}, ${latlng.lng.toFixed(5)}`
  }

  disconnect() {
    if (this.map) {
      this.map.remove()
      this.map = null
    }
  }
}
