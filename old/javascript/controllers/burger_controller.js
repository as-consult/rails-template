import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="burger"
export default class extends Controller {
  static targets = ["burger", "icon"];

  connect() {
    console.log("Burger connected!");
  }

  menu() {
    this.burgerTarget.classList.toggle("show");
    if (this.iconTarget.innerHTML == "┅") {
      this.iconTarget.innerHTML = "⁝";
    } else {
      this.iconTarget.innerHTML = "┅";
    }
  }
}
