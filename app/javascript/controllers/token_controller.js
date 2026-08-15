import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="token"
export default class extends Controller {
  static targets = ["modal", "message", "copy_btn"];
  
  async open() {
    const target_copy_btn = this.copy_btnTarget;
    const target_message = this.messageTarget;
    // CSRFトークンの取得
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');

    try {
      const response = await fetch('/app_link', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken // Railsで必須の設定
        },
      });
      if (!response.ok) throw new Error('通信エラー');
      const data = await response.json(); // コントローラから返ってきたJSON
      target_copy_btn.value = data.api_token;
      target_message.textContent = data.message;
      
    } catch (error) {
      target_message.textContent = "発行が失敗しました";
    }

    const target_modal = this.modalTarget;
    target_modal.classList.add("block");
    target_modal.classList.remove("hidden");
  }

  close() {
    const target_modal = this.modalTarget;
    target_modal.classList.add("hidden");
    target_modal.classList.remove("block");
  }

  async copy() {
    const target_copy_btn = this.copy_btnTarget;
    
    try {
      // クリップボードへのコピー
      await navigator.clipboard.writeText(target_copy_btn.value);
      // コピーしたことの表示
      alert('コピーしました');
    } catch (err) {
      alert('コピーに失敗しました');
    }
  }
}
