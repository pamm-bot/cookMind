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
    this.observer.observe(this.element, { childList: true, subtree: true, characterData: true })

    // re-scroll après une navigation Turbo complète (ex: redirection après streaming)
    this.turboLoadHandler = () => {
      // léger délai pour laisser le temps au DOM de finir de se mettre à jour
      setTimeout(() => this.scrollToBottom(), 50)
    }
    document.addEventListener("turbo:load", this.turboLoadHandler)
  }

  disconnect() {
    // arrête l'observation quand on quitte la page
    this.observer.disconnect()
    document.removeEventListener("turbo:load", this.turboLoadHandler)
  }

  scrollToBottom() {
    // positionne le scroll de la fenêtre tout en bas
    window.scrollTo(0, document.body.scrollHeight)
  }
}
