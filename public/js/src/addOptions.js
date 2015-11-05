function Overlay(overlayElement, openTrigger, closeTrigger) {
  this.overlayElement = document.getElementById(overlayElement);
  this.openTrigger = document.getElementById(openTrigger);
  this.closeTrigger = document.getElementById(closeTrigger);
}

Overlay.prototype = {
  constructor: Overlay,
  triggerOverlay: function() {
    if(this.overlayElement.style.visibility === "visible") {
      this.overlayElement.style.visibility = "hidden"; 
    } else {
      this.overlayElement.style.visibility = "visible";
    }
  },
  init: function() {
    this.openTrigger.addEventListener("click", this.triggerOverlay.bind(this), false);
    this.closeTrigger.addEventListener("click", this.triggerOverlay.bind(this), false);
  }
}

var addTranItem = new Overlay("transactionOverlay", "addTransactionItem", "closeTranOverlay");
addTranItem.init();

var addAccountItem = new Overlay("accountOverlay", "addAccountItem", "closeAccountOverlay");
addAccountItem.init();

var addBudgetItem = new Overlay("budgetOverlay","addBudgetItem", "closeBudgetOverlay");
addBudgetItem.init();
