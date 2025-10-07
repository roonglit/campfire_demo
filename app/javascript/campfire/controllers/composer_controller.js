import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["text"]

  submit(event) {
    event.preventDefault()

    if (this.#validInput()) {
      this.element.requestSubmit()
    }
  }

  submitByKeyboard(event) {
    const metaEnter = event.key == "Enter" && (event.metaKey || event.ctrlKey)
    const plainEnter = event.keyCode == 13 && !event.shiftKey && !event.isComposing

    if (metaEnter || plainEnter) {
      this.submit(event)
    }
  }

  #validInput() {
    return this.textTarget.textContent.trim().length > 0
  }
}
