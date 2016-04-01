$ = require 'jquery'
Helper = require './helper'
class Total
  parseTotals: (data) ->
    networth = document.getElementById("networthTotal")
    budgetBalance = document.getElementById("budgetBalance")
    incomeTotal = document.getElementById("incomeTotal")
    expenseTotal = document.getElementById("expenseTotal")
    
    
    Helper.parseTotal(networth, data.networth)
    Helper.parseTotal(budgetBalance, data.budget_balance)
    Helper.parseTotal(incomeTotal, data.income)
    expenseTotal.innerHTML = "- " + data.expense.toFixed(2)

  getTotals: () ->
    $.get('/totals', @parseTotals)
    .success()
    .complete( () ->
      $('#totalSpinner').hide()
      return true
    )

    return true

module.exports = Total
