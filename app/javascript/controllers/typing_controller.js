import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="typing"
export default class extends Controller {
  // on déclare les targets : l'indicateur et le bouton
  static targets = ["indicator", "button"]

  submit() {
    // on affiche l'indicateur "L'IA est en train d'écrire..."
    this.indicatorTarget.classList.remove("d-none")
    // on désactive le bouton pour éviter les double envois
    this.buttonTarget.disabled = true
  }

  reset() {
    // on cache l'indicateur quand l'IA a répondu
    this.indicatorTarget.classList.add("d-none")
    // on réactive le bouton
    this.buttonTarget.disabled = false
  }
}
