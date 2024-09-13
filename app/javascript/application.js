import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import { registerControllers } from "stimulus-vite-helpers"
import * as controllers from "./controllers"

// Stimulusアプリケーションをスタート
const application = Application.start()

// コントローラーの自動読み込み
eagerLoadControllersFrom("controllers", application)

// 手動でSortableコントローラーを登録
import SortableController from "./controllers/sortable_controller"
application.register("sortable", SortableController)
