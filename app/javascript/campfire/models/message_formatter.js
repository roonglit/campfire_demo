export default class MessageFormatter {
  #userId
  #classes

  constructor(userId, classes) {
    this.#userId = userId
    this.#classes = classes
  }

  format(message) {
    this.#setMeClass(message)
    this.#makeVisible(message)
  }

  #setMeClass(message) {
    const isMe = message.dataset.userId == this.#userId
    message.classList.toggle(this.#classes.me, isMe)
  }

  #makeVisible(message) {
    message.classList.add(this.#classes.formatted)
  }
}
