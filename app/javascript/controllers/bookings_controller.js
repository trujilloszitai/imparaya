import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["status", "form"]
  
  connect() {
    console.log("Bookings controller connected")
  }
  
  updateStatus(event) {
    event.preventDefault()
    const form = this.formTarget
    
    // Submit form via Turbo
    form.requestSubmit()
  }
  
  confirmCancel(event) {
    if (!confirm("¿Estás seguro de cancelar esta reserva?")) {
      event.preventDefault()
      event.stopPropagation()
    }
  }
}
