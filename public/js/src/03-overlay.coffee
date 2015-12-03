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
    @openTrigger.addEventListener("click", this.triggerOverlay, false)
    @closeTrigger.addEventListener("click", this.triggerOverlay, false)
    true

addTranItem = new Overlay("transactionOverlay", "addTransactionItem", "closeTranOverlay")
addTranItem.init()

addAccountItem = new Overlay("accountOverlay", "addAccountItem", "closeAccountOverlay")
addAccountItem.init()

addBudgetItem = new Overlay("budgetOverlay","addBudgetItem", "closeBudgetOverlay")
addBudgetItem.init()
