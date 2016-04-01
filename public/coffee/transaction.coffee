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
      for my_tag in transaction.tag_names
        tag = document.createElement("span")
        tag.innerHTML = my_tag
        tags.appendChild(tag)

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
    $.get('/transactions', @parseTransactions)
    .fail( () ->
    )
    .done( () ->
      $("#transactionSpinner").hide()
      true
    )
    true

  addMoreTransactions: (number) =>
    transactionRefresh = document.getElementById("transactionRefresh")

module.exports = Transaction
