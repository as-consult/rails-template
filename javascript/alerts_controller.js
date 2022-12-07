import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["notice"];

  connect() {
    console.log("Alerts connected!");
    setTimeout(() => {
      this.fadeOut();
    }, 5000);
    setTimeout(() => {
      this.close();
    }, 7000);
  }

  fadeOut() {
    this.noticeTarget.classList.add("alert-fadeout");
  }

  close() {
    this.noticeTarget.parentNode.removeChild(this.noticeTarget);
  }
}
