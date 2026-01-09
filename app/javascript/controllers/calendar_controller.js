import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["day", "event"]
  
  connect() {
    console.log("Calendar controller connected")
    this.highlightToday()
  }
  
  highlightToday() {
    const today = new Date().toDateString()
    this.dayTargets.forEach(day => {
      const dayDate = new Date(day.dataset.date).toDateString()
      if (dayDate === today) {
        day.classList.add("today")
      }
    })
  }
  
  showEventDetails(event) {
    const eventId = event.currentTarget.dataset.eventId
    console.log("Show event details:", eventId)
    // Aquí puedes agregar lógica para mostrar detalles del evento
  }
}
