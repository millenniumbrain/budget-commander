class Helpers
  @floatToDecimal = (number) =>
    decimalNumber = parseFloat(number)

  @checkAmountNumber = (el, amount) =>
    if amount < 0
      el.setAttribute("class", "amount expense")
      el.innerHTML = this.floatToDecimal(amount)
    else
      el.setAttribute("class", "amount income")
      el.innerHTML = "+" + this.floatToDecimal(amount)
