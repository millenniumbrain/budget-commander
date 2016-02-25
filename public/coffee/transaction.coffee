$ = require 'jquery'
moment = require 'moment'
Helper = require './helper'

class Transaction

  parseTransactions: (data) =>
    table = document.querySelector('#transactionActivity tbody')
    data.map( (transaction) ->
      row = document.createElement("tr")
      date = document.createElement("td")
      date.setAttribute("class", "date-cell")
      date.innerHTML = moment(transaction.date).format("MMM DD")

      amount = document.createElement("td")
      Helper.parseAmount(amount, transaction.type, transaction.amount)

      description = document.createElement("td")
      description.setAttribute("class", "description-cell")
      description.innerHTML = transaction.description

      tags = document.createElement("td")
      tags.setAttribute("class", "tags-cell")
      tags.innerHTML = "Entertainment"

      accountName = document.createElement("td")
      accountName.setAttribute("class", "account-cell")
      accountName.innerHTML = transaction.account_id

      row.appendChild(date)
      row.appendChild(amount)
      row.appendChild(description)
      row.appendChild(tags)
      row.appendChild(accountName)
      table.appendChild(row)

      true
    )
    true

  getTransactions: () =>
    $.get('/transactions', this.parseTransactions)
    .success( () ->
    )
    .complete( () ->
      $("#transactionSpinner").hide()
      true
    )
    true

module.exports = Transaction
