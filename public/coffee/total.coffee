$ = require 'jquery'

class Total
  parseTotals: (data) ->
    networth = document.getElementById("networthTotal")
    budgetBalance = document.getElementById("budgetBalance")
    incomeTotal = document.getElementById("incomeTotal")
    expenseTotal = document.getElementById("expenseTotal")

    networth.innerHTML = "+ " + data.networth
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
