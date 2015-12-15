class Helpers
  @setAmountClass = (el, amount) =>
    if amount >= 0
      el.setAttribute("class", "income")
      el.innerHTML = "+" + amount
    else
      el.setAttribute("class", "expense")
      el.innerHTML = amount

  @floatToDecimal = (number) =>
    decimalNumber = parseFloat(number)

  @parseAmount = (el, type, amount) =>
    if type == "expense"
      el.setAttribute("class", "amount expense")
      el.innerHTML = this.floatToDecimal(amount)
    else
      el.setAttribute("class", "amount income")
      el.innerHTML = "+" + this.floatToDecimal(amount)
