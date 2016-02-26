$ = require 'jquery'

class Total
  parseTotals: (data) ->
    networth = document.getElementById("networthTotal")
    budgetBalance = document.getElementById("budgetBalance")
    incomeTotal = document.getElementById("incomeTotal")
    expenseTotal = document.getElementById("expenseTotal")

    if data.networth >= 0
      networth.setAttribute("class", "total-amount green-amount")
      networth.innerHTML = "+ " + data.networth.toFixed(2)
    else
      networth.setAttribute("class", "total-amount red-amount")
      networth.innerHTML = data.networth.toFixed(2)
    budgetBalance.innerHTML = "+ " + data.budget_balance
    incomeTotal.innerHTML = "+ " + data.income
    expenseTotal.innerHTML = "- " + data.expense

  getTotals: () ->
    $.get('/totals', @parseTotals)
    .success()
    .complete( () ->
      $('#totalSpinner').hide()
      return true
    )

    return true

module.exports = Total
