$ = require 'jquery'
Form = require './form'

class TransactionForm
  constructor: (form) ->
    @accountsUrl = '/accounts'
    @dateRegExp = /(?:[A-Z]{1}[a-z]{2}\s\d{2}\s\d{4})/
    #@amountRegUSD = /(?:\d+\.\d{2})/
    @form = $(form)


  init: () =>
    transactionAccounts = document.getElementById("newTransactionAccounts")
    $.get(@accountsUrl, (data) ->
      data.map( (account) ->
        option = document.createElement("option")
        option.innerHTML = account.name
        transactionAccounts.appendChild(option)
        true
      )
      true
    )
    true

    submit: () =>
      @form.on("submit", (event) ->
        event.preventDefault()
        $.post('/transactions')
        .beforeSend( () ->
          
        )
      )


module.exports = TransactionForm
