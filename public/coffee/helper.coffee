class Helper
  @floatToDecimal: (number) ->
    decimalNumber = parseFloat(number).toFixed(2)

  @parseAmount: (el, type, amount) ->
    switch type
      when "expense"
        el.setAttribute("class", "red-amount amount-cell")
        el.innerHTML = "-" + @floatToDecimal(amount)
      when "income"
        el.setAttribute("class", "green-amount amount-cell")
        el.innerHTML = "+" + @floatToDecimal(amount)
  
  @parseTotal: (el, amount) ->
    if amount >= 0
      el.setAttribute("class", "green-amount total-amount")
      el.innerHTML = "+" + @floatToDecimal(amount)
    else
      el.setAttribute("class", "red-amount total-amount")
      el.innerHTML = "-" + @floatToDecimal(amount)


module.exports = Helper
