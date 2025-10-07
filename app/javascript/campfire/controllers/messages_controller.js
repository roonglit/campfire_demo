import { Controller } from "@hotwired/stimulus"
import MessageFormatter from "campfire/models/message_formatter"

export default class extends Controller {
  static targets = ["message"]
  static classes = ["formatted", "me"]

  #formatter

  initialize() {
    const messagesContainer = document.getElementById("messages")
    const currentUserId = messagesContainer?.dataset.currentUserId

    console.log("Messages controller initialized, current user ID:", currentUserId)

    this.#formatter = new MessageFormatter(currentUserId, {
      formatted: this.formattedClass,
      me: this.meClass,
    })
  }

  connect() {
    this.scrollToBottom()
  }

  messageTargetConnected(target) {
    console.log("Message target connected:", target, "User ID:", target.dataset.userId)
    this.#formatter.format(target)
    this.scrollToBottom()
  }

  scrollToBottom() {
    requestAnimationFrame(() => {
      this.element.scrollTop = this.element.scrollHeight
    })
  }
}
