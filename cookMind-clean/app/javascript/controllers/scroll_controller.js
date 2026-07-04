import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll"
export default class extends Controller {

  connect() {
    // scroll vers le bas au chargement
    this.scrollToBottom()

    // observe les changements dans la div messages
    this.observer = new MutationObserver(() => {
      this.scrollToBottom()
    })

    this.observer.observe(this.element, { childList: true, subtree: true })
  }

  disconnect() {
    // arrête l'observation quand on quitte la page
    this.observer.disconnect()
  }

  scrollToBottom() {
    // positionne le scroll tout en bas
    this.element.scrollTop = this.element.scrollHeight
  }
}
