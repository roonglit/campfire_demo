const EMOJI_MATCHER = /^(\p{Emoji_Presentation}|\p{Extended_Pictographic}|\uFE0F)+$/gu

export default class ClientMessage {
  #template

  constructor(template) {
    this.#template = template
  }

  render(clientMessageId, node) {
    const now = new Date()
    const body = this.#contentFromNode(node)

    return this.#createFromTemplate({
      clientMessageId,
      body,
      messageTimestamp: Math.floor(now.getTime()),
      messageDatetime: now.toISOString(),
      messageClasses: this.#containsOnlyEmoji(node.textContent) ? "message--emoji" : "",
    })
  }

  update(clientMessageId, body) {
    const element = this.#findWithId(clientMessageId)?.querySelector(".message__body-content")

    if (element) {
      element.innerHTML = body
    }
  }

  failed(clientMessageId) {
    const element = this.#findWithId(clientMessageId)

    if (element) {
      element.classList.add("message--failed")
    }
  }

  #findWithId(clientMessageId) {
    return document.querySelector(`#message_${clientMessageId}`)
  }

  #contentFromNode(node) {
    if (this.#isRichText(node)) {
      return this.#richTextContent(node)
    } else {
      return node
    }
  }

  #isRichText(node) {
    return typeof(node) != "string"
  }

  #richTextContent(node) {
    return `<div class="trix-content">${node.innerHTML}</div>`
  }

  #createFromTemplate(data) {
    let html = this.#template.innerHTML

    for (const key in data) {
      html = html.replaceAll(`$${key}$`, data[key])
    }

    return html
  }

  #containsOnlyEmoji(text) {
    return text?.match(EMOJI_MATCHER)
  }
}
