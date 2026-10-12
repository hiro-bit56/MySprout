import { Controller } from "@hotwired/stimulus"
import { Chart } from "chart.js/auto"

// Connects to data-controller="mood-graph"
export default class extends Controller {
  
  async connect() {
    this.controller = new AbortController();
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');

    this.referenceDate = new Date();
    const date = {
      referenceOn: procDate(this.referenceDate)
    } 

    try {
      const response = await fetch('/graph/mood_month', {
        signal: this.controller.signal,
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken // Railsで必須の設定
        },
        body: JSON.stringify(date)
      });
      if (!response.ok) throw new Error('通信エラー');
      const data = await response.json(); // コントローラから返ってきたJSON
      document.getElementById('date-range').textContent = data.formatted_date_range;
      this.monthGraphDataset = procMoodGraph(data.month_graph_data);
    } catch (error) {
      if (error.name === "AbortError") {
        console.log("ページ移動のためfetchを中断しました")
      } else {
        console.error(error)
        alert("通信が失敗しました")
      }
    }
  }

  disconnect() {
    if (this.monthGraphDataset) {
      this.monthGraphDataset.destroy()
      this.monthGraphDataset = null
    }
    this.controller.abort();
  }

  async backMonth() {
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');

    let d = this.referenceDate;
    d.setDate(d.getDate() - 30);
    this.referenceDate = d;
    const date = {
      referenceOn: procDate(this.referenceDate)
    } 

    try {
      const response = await fetch('/graph/mood_month', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken // Railsで必須の設定
        },
        body: JSON.stringify(date)
      });
      if (!response.ok) throw new Error('通信エラー');
      const data = await response.json(); // コントローラから返ってきたJSON
      document.getElementById('date-range').textContent = data.formatted_date_range;
      if(this.monthGraphDataset) {
        this.monthGraphDataset.data.datasets[0].data = data.month_graph_data;
        this.monthGraphDataset.update();
      } else {
        this.monthGraphDataset = procMoodGraph(data.month_graph_data);
      }
    } catch (error) {
      console.error(error)
      alert("通信が失敗しました");
    }
  }

  async nextMonth() {
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');

    let d = this.referenceDate;
    d.setDate(d.getDate() + 30);
    this.referenceDate = d;
    if(this.referenceDate > new Date()) {
      this.referenceDate = new Date();
    }
    const date = {
      referenceOn: procDate(this.referenceDate)
    } 

    try {
      const response = await fetch('/graph/mood_month', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken // Railsで必須の設定
        },
        body: JSON.stringify(date)
      });
      if (!response.ok) throw new Error('通信エラー');
      const data = await response.json(); // コントローラから返ってきたJSON
      document.getElementById('date-range').textContent = data.formatted_date_range;
      if(this.monthGraphDataset) {
        this.monthGraphDataset.data.datasets[0].data = data.month_graph_data;
        this.monthGraphDataset.update();
      } else {
        this.monthGraphDataset = procMoodGraph(data.month_graph_data);
      }
    } catch (error) {
      console.error(error)
      alert("通信が失敗しました");
    }
  }
}

function procDate(referenceDate){
  const year = referenceDate.getFullYear();
  const month = String(referenceDate.getMonth() + 1).padStart(2, '0'); // 月は0から始まるため+1
  const day = String(referenceDate.getDate()).padStart(2, '0');

  const formattedDate = `${year}-${month}-${day}`;
  return formattedDate
}

function procMoodGraph(data) {
  return new Chart(
    document.getElementById('moodGraph'),
    {
      type: "line",
      data: {
        datasets: [
          {
            label: "気分",
            data: data,
            tension: 0.4
          }
        ]
      },
      options: {
        responsive: true,           // 親要素のサイズに追従させる
        maintainAspectRatio: false, // 元の縦横比を無視して枠いっぱいに広げる
        plugins: {
          legend: {
            display: false // 凡例を非表示
          }
        },
        scales: {
           x: {
            ticks: {
              callback: function(value, index, ticks) {
                // 5データごとにのみ処理を行う（0, 5, 10, 15...番目のデータ）
                if (index % 5 === 0 || index === ticks.length - 1) {
                  const label = this.getLabelForValue(value);
                  return label.slice(8); // 日付（dd）だけを返す
                }
                // それ以外はnullを返すと非表示
                return null
              }
            }
          },
          y: {
            suggestedMin: 0,
            suggestedMax: 4,
            stepSize: 1,
            reverse: true,
            ticks: {
              callback: function(value) {
                switch(value) {
                  case 0:
                    return "最高";
                  case 1:
                    return "良い";
                  case 2:
                    return "普通";
                  case 3:
                    return "悪い";
                  case 4:
                    return "最悪";
                }
              }
            }
          }
        }
      }
    }
  );
}