import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  switch(event) {
    // 使用方法
    // btnにid = 〇〇
    // 表示させたいテキストにid = 〇〇-text
    const clickedElement = event.target;
    const btnId = clickedElement.id;
    const textElement = document.getElementById(btnId + "-text");
    if (textElement.classList.contains('hidden')) {
      textElement.classList.replace("hidden", "block");
      clickedElement.textContent = "▲";
    }else{
      textElement.classList.replace("block", "hidden");
      clickedElement.textContent = "▼";
    }
  }
}
