$ = require 'jquery'

class Overlay
  constructor: (overlay, openTrigger, closeTrigger) ->
    @overlay = document.getElementById(overlay)
    @openTrigger = document.getElementById(openTrigger)
    @closeTrigger = document.getElementById(closeTrigger)

  triggerOverlay: () =>
    if @overlay.style.visibility == "visible"
      @overlay.style.visibility = "hidden"
    else
      @overlay.style.visibility = "visible"

  init: () =>
    @openTrigger.addEventListener("click", @triggerOverlay, false)
    @closeTrigger.addEventListener("click", @triggerOverlay, false)
    true



module.exports = Overlay
