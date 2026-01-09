import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dayOfWeek", "startTime", "endTime", "price"]
  
  connect() {
    console.log("Availabilities controller connected")
  }
  
  validateTimes() {
    const startTime = this.startTimeTarget.value
    const endTime = this.endTimeTarget.value
    
    if (startTime && endTime && startTime >= endTime) {
      alert("La hora de fin debe ser posterior a la hora de inicio")
      return false
    }
    return true
  }
  
  confirmDelete(event) {
    if (!confirm("¿Estás seguro? Las reservas asociadas ya creadas permanecerán intactas.")) {
      event.preventDefault()
      event.stopPropagation()
    }
  }
}
