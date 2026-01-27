import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "status", "updateButton"]
  
  connect() {
    console.log("Bookings controller connected")
  }
  
  updateStatus(event) {
    event.preventDefault()
    const form = this.formTarget
    
    // Submit form via Turbo
    form.requestSubmit()
  }

  toggleSubmit(event) {
    event.preventDefault()
    
    const currentStatus = event.target.dataset.currentStatus
    const statusSelect = this.statusTarget
    const updateButton = this.updateButtonTarget

    updateButton.disabled = (statusSelect.value == currentStatus)
  }
  
  confirmCancel(event) {
    if (!confirm("¿Estás seguro de cancelar esta reserva?")) {
      event.preventDefault()
      event.stopPropagation()
    }
  }
}
