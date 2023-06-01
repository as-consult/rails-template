import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["account", "flag"];

  connect() {
    console.log("Submenu connected!");
  }

  burgermenu() {
    this.accountTarget.classList.toggle("show");
  }
  flagmenu() {
    this.flagTarget.classList.toggle("show");
  }
}
