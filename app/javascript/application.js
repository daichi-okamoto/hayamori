import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import { registerControllers } from "stimulus-vite-helpers"
import * as controllers from "./controllers"

const application = Application.start()
eagerLoadControllersFrom("controllers", application)
