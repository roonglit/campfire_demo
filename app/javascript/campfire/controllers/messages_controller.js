import { Controller } from "@hotwired/stimulus"
import MessageFormatter from "campfire/models/message_formatter"
import ClientMessage from "campfire/models/client_message"

export default class extends Controller {
  static targets = ["latest", "message", "messages", "template"]
  static classes = ["firstOfDay", "formatted", "me", "mentioned", "threaded"]
  static values = { pageUrl: String }

  #formatter
  #clientMessage

  initialize() {
    const currentUserId = document.querySelector('meta[name="current-user-id"]')?.content

    console.log("Messages controller initialized, current user ID:", currentUserId)

    this.#formatter = new MessageFormatter(currentUserId, {
      firstOfDay: this.firstOfDayClass,
      formatted: this.formattedClass,
      me: this.meClass,
      mentioned: this.mentionedClass,
      threaded: this.threadedClass,
    })
  }

  connect() {
    if (this.hasTemplateTarget) {
      this.#clientMessage = new ClientMessage(this.templateTarget)
    }
    this.scrollToBottom()
  }

  messageTargetConnected(target) {
    console.log("Message target connected:", target, "User ID:", target.dataset.userId)
    this.#formatter.format(target)
    this.scrollToBottom()
  }

  // Actions

  async beforeStreamRender(event) {
    const target = event.detail.newStream?.getAttribute("target")

    if (target === this.messagesTarget?.id) {
      const render = event.detail.render

      // Always render the new content and scroll to bottom
      event.detail.render = async (streamElement) => {
        await render(streamElement)
        this.scrollToBottom()

        if (this.hasLatestTarget) {
          this.latestTarget.hidden = true
        }
      }
    }
  }

  async returnToLatest() {
    if (this.hasLatestTarget) {
      this.latestTarget.hidden = true
    }
    this.scrollToBottom()
  }

  async editMyLastMessage() {
    const editorEmpty = document.querySelector("#composer trix-editor")?.matches(":empty")

    if (editorEmpty) {
      this.#myLastMessage?.querySelector(".message__edit-btn")?.click()
    }
  }

  // Outlet actions - called by composer controller

  async insertPendingMessage(clientMessageId, node) {
    if (!this.#clientMessage) return

    return this.scrollToBottom(async () => {
      const message = this.#clientMessage.render(clientMessageId, node)
      if (this.hasMessagesTarget) {
        this.messagesTarget.insertAdjacentHTML("beforeend", message)
      }
    })
  }

  updatePendingMessage(clientMessageId, body) {
    if (this.#clientMessage) {
      this.#clientMessage.update(clientMessageId, body)
    }
  }

  failPendingMessage(clientMessageId) {
    if (this.#clientMessage) {
      this.#clientMessage.failed(clientMessageId)
    }
  }

  // Internal methods

  scrollToBottom(callback) {
    return new Promise(resolve => {
      requestAnimationFrame(async () => {
        if (callback) {
          await callback()
        }

        if (this.hasMessagesTarget) {
          this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
        } else {
          this.element.scrollTop = this.element.scrollHeight
        }

        resolve()
      })
    })
  }

  get #myLastMessage() {
    if (!this.hasMessagesTarget || !this.hasMeClass) return null

    const myMessages = this.messagesTarget.querySelectorAll(`.${this.meClass}`)
    return myMessages[myMessages.length - 1]
  }
}
