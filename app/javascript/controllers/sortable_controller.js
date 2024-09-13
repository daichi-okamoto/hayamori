import { Controller } from "@hotwired/stimulus";
import Sortable from "sortablejs";

export default class extends Controller {
  connect() {
    console.log("SortableJS is connected");
    this.sortable = Sortable.create(this.element, {
      onEnd: this.end.bind(this) // ドラッグ終了時の処理
    });
  }

  end(event) {
    let order = [];
    this.element.querySelectorAll("tr").forEach((row, index) => {
      order.push({
        id: row.dataset.id,
        position: index + 1
      });
    });

    fetch("/employees/sort", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute("content")
      },
      body: JSON.stringify({ order: order })
    });
  }
}
