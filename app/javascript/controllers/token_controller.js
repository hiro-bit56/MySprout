import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="token"
export default class extends Controller {
  static targets = ["modal", "message", "copy"];
  
  // モーダルの表示
  async open() {
    const target_copy = this.copyTarget;
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
      target_copy.value = data.api_token;
      target_message.textContent = data.message;
      
    } catch (error) {
      target_message.textContent = "発行が失敗しました";
    }

    const target_modal = this.modalTarget;
    target_modal.classList.add("block");
    target_modal.classList.remove("hidden");
  }

  // モーダルの非表示
  close() {
    const target_modal = this.modalTarget;
    target_modal.classList.add("hidden");
    target_modal.classList.remove("block");
  }

  // 外部アプリのエクスポート用cURLをクリップボードへコピー
  async urlCopy() {
    const curl = "curl https://mysprout.onrender.com/api/mood_records -X POST -H 'Authorization: Bearer YOUR_TOKEN' -H 'Content-Type: application/json' -d '{\"mood_level\": \"tmp\"}'";
    // const curl = 'curl https://mysprout.onrender.com/api/mood_records -X POST -H "Authorization: Bearer  YOUR_TOKEN" -H "Content-Type: application/json" -d "{\"mood_level\": \"tmp\"}"';

    try {
      // 方法1: Clipboard API(HTTPS環境)
      if (navigator.clipboard && navigator.clipboard.writeText) {
        await navigator.clipboard.writeText(curl);
        alert('コピーしました');
        return;
      }
      // 方法2: 古い方法(HTTP環境でも動作)
      fallbackCopyToClipboard(curl);
      alert('コピーしました');
    } catch (err) {
      alert('コピーに失敗しました');
    }
  }

  // トークンをクリップボードへコピー
  async tokenCopy() {
    const target_copy = this.copyTarget;

    try {
      // 方法1: Clipboard API(HTTPS環境)
      if (navigator.clipboard && navigator.clipboard.writeText) {
        await navigator.clipboard.writeText(target_copy.value);
        alert('コピーしました');
        return;
      }
      // 方法2: 古い方法(HTTP環境でも動作)
      fallbackCopyToClipboard(target_copy.value);
      alert('コピーしました');
    } catch (err) {
      alert('コピーに失敗しました');
    }
  }


}

// 古い方法でのコピー(内容をよく理解しておく)
function fallbackCopyToClipboard(text) {
  const textArea = document.createElement('textarea');
  textArea.value = text;
  
  // 画面外に配置
  textArea.style.position = 'fixed';
  textArea.style.top = '0';
  textArea.style.left = '0';
  textArea.style.width = '2em';
  textArea.style.height = '2em';
  textArea.style.padding = '0';
  textArea.style.border = 'none';
  textArea.style.outline = 'none';
  textArea.style.boxShadow = 'none';
  textArea.style.background = 'transparent';
  
  document.body.appendChild(textArea);
  textArea.focus();
  textArea.select();
  
  try {
    const successful = document.execCommand('copy');
    if (!successful) {
      throw new Error('execCommand failed');
    }
  } catch (err) {
    throw err;
  } finally {
    document.body.removeChild(textArea);
  }
}
