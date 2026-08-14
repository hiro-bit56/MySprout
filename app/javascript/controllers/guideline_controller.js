import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="guideline"
export default class extends Controller {
  static targets = ["text", "button"];
  
  switch() {
    const target_text = this.textTarget;
    const target_button = this.buttonTarget;
    if (target_text.classList.contains('hidden')) {
      target_text.classList.replace("hidden", "block");
      target_button.textContent = "▲";
    }else{
      target_text.classList.replace("block", "hidden");
      target_button.textContent = "▼";
    }
  }
}
