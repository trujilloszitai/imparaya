import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
    connect() {
        console.log("Navigation controller connected")
    }

    static values = { url: String }

    goToUrl() {
        Turbo.visit(this.urlValue)
    }
}