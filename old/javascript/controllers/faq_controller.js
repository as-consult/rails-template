import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="faq"
export default class extends Controller {
  static targets = ["answer"];

  connect() {
    console.log("FAQ connected!");
  }

  show(event) {
    for (var answer of this.answerTargets) {
      if (answer.id == event.originalTarget.parentElement.id) {
        answer.classList.toggle("show");
        event.originalTarget.parentElement.classList.toggle("rotate");
      }
    }
  }
}
