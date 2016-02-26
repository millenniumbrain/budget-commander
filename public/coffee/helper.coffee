class Helper
  @floatToDecimal: (number) ->
    decimalNumber = parseFloat(number)

  @parseAmount: (el, type, amount) ->
    switch type
      when "expense"
        el.setAttribute("class", "red-amount amount-cell")
        el.innerHTML = "-" + @floatToDecimal(amount).toFixed(2)
      when "income"
        el.setAttribute("class", "green-amount amount-cell")
        el.innerHTML = "+" + @floatToDecimal(amount).toFixed(2)

module.exports = Helper
