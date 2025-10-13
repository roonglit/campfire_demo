import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = ["toolbar"]
  static targets = ["clientid", "fields", "fileList", "text"]
  static values = { roomId: Number }
  static outlets = ["messages"]

  #files = []

  connect() {
    if (!this.#usingTouchDevice) {
      setTimeout(() => this.textTarget.focus(), 1)
    }
  }

  submit(event) {
    event.preventDefault()

    if (this.hasFieldsTarget && !this.fieldsTarget.disabled) {
      this.#submitFiles()
      this.#submitMessage()
      this.collapseToolbar()
      this.textTarget.focus()
    } else if (this.#validInput()) {
      this.element.requestSubmit()
    }
  }

  submitEnd(event) {
    if (this.hasMessagesOutlet && !event.detail.success) {
      this.messagesOutlet.failPendingMessage(this.clientidTarget.value)
    }
  }

  submitByKeyboard(event) {
    const toolbarVisible = this.element.classList.contains(this.toolbarClass)
    const metaEnter = event.key == "Enter" && (event.metaKey || event.ctrlKey)
    const plainEnter = event.keyCode == 13 && !event.shiftKey && !event.isComposing

    if (!this.#usingTouchDevice && (metaEnter || (plainEnter && !toolbarVisible))) {
      this.submit(event)
    }
  }

  toggleToolbar() {
    this.element.classList.toggle(this.toolbarClass)
    this.textTarget.focus()
  }

  collapseToolbar() {
    if (this.hasToolbarClass) {
      this.element.classList.remove(this.toolbarClass)
    }
  }

  filePicked(event) {
    for (const file of event.target.files) {
      this.#files.push(file)
    }
    event.target.value = null
    this.#updateFileList()
  }

  fileUnpicked(event) {
    this.#files.splice(event.params.index, 1)
    this.#updateFileList()
  }

  pasteFiles(event) {
    if (event.clipboardData.files.length > 0) {
      event.preventDefault()
    }

    for (const file of event.clipboardData.files) {
      this.#files.push(file)
    }

    this.#updateFileList()
  }

  dropFiles({ detail: { files } }) {
    for (const file of files) {
      this.#files.push(file)
    }

    this.#updateFileList()
  }

  preventAttachment(event) {
    event.preventDefault()
  }

  online() {
    if (this.hasFieldsTarget) {
      this.fieldsTarget.disabled = false
    }
  }

  offline() {
    if (this.hasFieldsTarget) {
      this.fieldsTarget.disabled = true
    }
  }

  get #usingTouchDevice() {
    return 'ontouchstart' in window || navigator.maxTouchPoints > 0 || navigator.msMaxTouchPoints > 0;
  }

  async #submitMessage() {
    if (this.#validInput()) {
      const clientMessageId = this.#generateClientId()

      if (this.hasMessagesOutlet) {
        await this.messagesOutlet.insertPendingMessage(clientMessageId, this.textTarget)
        await new Promise(requestAnimationFrame)
      }

      if (this.hasClientidTarget) {
        this.clientidTarget.value = clientMessageId
      }
      this.element.requestSubmit()
      this.#reset()
    }
  }

  #validInput() {
    return this.textTarget.textContent.trim().length > 0
  }

  async #submitFiles() {
    // File upload functionality - simplified for now
    const files = this.#files
    this.#files = []
    this.#updateFileList()

    // TODO: Implement file upload with FileUploader when needed
    console.log("File upload not yet implemented", files)
  }

  #generateClientId() {
    return Math.random().toString(36).slice(2)
  }

  #reset() {
    this.textTarget.value = ""
  }

  #updateFileList() {
    if (!this.hasFileListTarget) return

    this.#files.sort((a, b) => a.name.localeCompare(b.name))

    const fileNodes = this.#files.map((file, index) => {
      const filename = file.name.split(".").slice(0, -1).join(".")
      const extension = file.name.split(".").pop()

      const node = document.createElement("button")
      node.setAttribute("type", "button")
      node.setAttribute("style", "gap: 0")
      node.dataset.action = "composer#fileUnpicked"
      node.dataset.composerIndexParam = index
      node.className = "btn btn--plain composer__file txt-normal position-relative unpad flex-column"

      if (file.type.match(/^image\/.*/)) {
        node.innerHTML = `<img role="presentation" class="flex-item-no-shrink composer__file-thumbnail" src="${URL.createObjectURL(file)}">`
      } else {
        node.innerHTML = `<span class="composer__file-thumbnail composer__file-thumbnail--common colorize--black"></span>`
      }

      const escapedFilename = this.#escapeHTML(filename)
      const escapedExtension = this.#escapeHTML(extension)
      node.innerHTML += `<span class="pad-inline txt-small flex align-center max-width composer__file-caption"><span class="overflow-ellipsis">${escapedFilename}.</span><span class="flex-item-no-shrink">${escapedExtension}</span></span>`

      return node
    })

    this.fileListTarget.replaceChildren(...fileNodes)
  }

  #escapeHTML(html) {
    const div = document.createElement("div")
    div.textContent = html
    return div.innerHTML
  }
}
