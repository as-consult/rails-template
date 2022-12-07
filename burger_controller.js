import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="burger"
export default class extends Controller {
  static targets = ["burger"];

  connect() {
    console.log("Burger connected!");
  }

  menu() {
    this.burgerTarget.classList.toggle("show");
  }
}
