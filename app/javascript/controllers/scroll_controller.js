import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll"
export default class extends Controller {
  connect() {
    // scroll vers le bas au chargement
    this.scrollToBottom()

    // relance le scroll une fois que Turbo a fini de charger la page
    document.addEventListener("turbo:load", this.scrollToBottom.bind(this))

    // observe les changements dans la div messages
    this.observer = new MutationObserver(() => {
      this.scrollToBottom()
    })

    this.observer.observe(this.element, { childList: true, subtree: true })
  }

  disconnect() {
    // arrête l'observation quand on quitte la page
    this.observer.disconnect()
    document.removeEventListener("turbo:load", this.scrollToBottom.bind(this))
  }

  scrollToBottom() {
    // positionne le scroll de toute la page tout en bas
    window.scrollTo(0, document.body.scrollHeight)
  }
}
