import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modals"
export default class extends Controller {
  connect() {
  }

  // hide modal
  // action: "modals#hideModal"
  hideModal() {
    this.element.parentElement.removeAttribute("src") 
    this.element.parentElement.removeAttribute("complete")
    this.element.remove()
  }
}
