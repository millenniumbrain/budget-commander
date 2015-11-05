function Helpers() {
}

Helpers.prototype = {
  consructor: Helpers,
  floatToDecimal: function (number) {
   var decimalNumber = parseFloat(number);
   return decimalNumber;
  },
  checkAmountNumber: function (el, amount) {
    if (amount < 0) { 
      el.setAttribute("class", "amount expense");
      el.innerHTML = this.floatToDecimal(amount);
    } else {
      el.setAttribute("class", "amount income");
      el.innerHTML = "+" + this.floatToDecimal(amount);
    }
  }
}

appHelpers = new Helpers();
