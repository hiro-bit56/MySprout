import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="token"
export default class extends Controller {
  static targets = ["issueBtn", "clearBtn"];
  
  // トークンの発行
  async issue() {
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
      // ボタンの有効化・無効化
      if (data.has_token){
        this.issueBtnTarget.disabled = true;
        this.issueBtnTarget.classList.replace("bg-[#98d98e]/50", "bg-[#808080]/50");
        this.issueBtnTarget.textContent = "発行済み";
        this.clearBtnTarget.disabled = false;
        this.clearBtnTarget.classList.replace("bg-[#808080]/50", "bg-[#98d98e]/50");
      }
      // トークンをクリップボードへコピー
      if (tokenCopy(data.token)){
        alert(data.message)
      } else {
        alert(
          "クリップボードへのコピーに失敗しました。\n" +
          "再度トークン発行をお試しください。\n" +
          "　※「連携解除」を行う必要があります。"
        );
      }
    } catch (error) {
      console.error(error);
      alert("発行が失敗しました");
    }

  }

  async clear() {
    // CSRFトークンの取得
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');

    try {
      const response = await fetch('/app_link', {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken // Railsで必須の設定
        },
      });
      if (!response.ok) throw new Error('通信エラー');
      const data = await response.json(); // コントローラから返ってきたJSON
      // ボタンの有効化・無効化
      if (!data.has_token){
        this.issueBtnTarget.disabled = false;
        this.issueBtnTarget.classList.replace("bg-[#808080]/50", "bg-[#98d98e]/50");
        this.issueBtnTarget.textContent = "トークン発行";
        this.clearBtnTarget.disabled = true;
        this.clearBtnTarget.classList.replace("bg-[#98d98e]/50", "bg-[#808080]/50");
      }
      alert(data.message)
    } catch (error) {
      alert("連携解除に失敗しました");
    }

  }

  // 外部アプリのエクスポート用cURLをクリップボードへコピー
  async urlCopy() {
    const curl = "curl https://mysprout.onrender.com/api/endpoint -X POST -H 'Authorization: Bearer YOUR_TOKEN' -H 'Content-Type: application/json' -d '{\"mood_level\": \"tmp\"}'";
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
}

// トークンをクリップボードへコピー
async function tokenCopy(token) {
  try {
    // 方法1: Clipboard API(HTTPS環境)
    if (navigator.clipboard && navigator.clipboard.writeText) {
      await navigator.clipboard.writeText(token);
      return true;
    }
    // 方法2: 古い方法(HTTP環境でも動作)
    fallbackCopyToClipboard(token);
    return true;
  } catch (err) {
    return false;
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
