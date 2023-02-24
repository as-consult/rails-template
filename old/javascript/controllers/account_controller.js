import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="burger"
export default class extends Controller {
  static targets = ["account"];

  connect() {
    console.log("Account connected!");
  }

  menu() {
    this.accountTarget.classList.toggle("show");
  }
}
