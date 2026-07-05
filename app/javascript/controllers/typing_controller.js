import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["indicator", "button"]

  submit() {
    this.indicatorTarget.classList.remove("d-none")
    this.buttonTarget.disabled = true

    const form = this.element
    setTimeout(() => form.reset(), 0)
  }

  reset() {
    this.indicatorTarget.classList.add("d-none")
    this.buttonTarget.disabled = false
  }
}
