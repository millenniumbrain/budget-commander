$ = require 'jquery'
Form = require './form'
moment = require 'moment'
Helper = require './helper'

class TransactionForm
  constructor: (form) ->
    @accountsUrl = '/accounts'
    @dateRegExp = /(?:[A-Z]{1}[a-z]{2}\s\d{2}\s\d{4})/
    #@amountRegUSD = /(?:\d+\.\d{2})/
    @form = $(form)


  #init: () =>
   # transactionAccounts = document.getElementById("newTransactionAccounts")
   # $.get(@accountsUrl, (data) ->
   #   data.map( (account) ->
   #     option = document.createElement("option")
   #     option.innerHTML = account.name
   #     option.value = account.name
   #     transactionAccounts.appendChild(option)
   #     true
   #   )
   #   true
   # )
   # true

  addTransaction: (data) =>
    table = document.querySelector('#transactionActivity tbody')
    $.get('/transactions/count', (data) ->
      $.get('/transactions/all/' + data, (data) ->
        row = document.createElement("tr")
        date = document.createElement("td")
        date.setAttribute("class", "date-cell")
        date.innerHTML = moment(data["date"]).format("MMM DD")

        amount = document.createElement("td")
        Helper.parseAmount(amount, data["type"], data["amount"])

        description = document.createElement("td")
        description.setAttribute("class", "description-cell")
        description.innerHTML = data["description"]

        tags = document.createElement("td")
        tags.setAttribute("class", "tags-cell")
        tags.innerHTML = "Entertainment"

        accountName = document.createElement("td")
        accountName.setAttribute("class", "account-cell")
        accountName.innerHTML = data["account_id"]
        console.log(row)
        row.appendChild(date)
        row.appendChild(amount)
        row.appendChild(description)
        row.appendChild(tags)
        row.appendChild(accountName)
        table.appendChild(row)
        true
      )
      true
    )

  submit: () =>
    @form.on("submit", (event) ->
      event.preventDefault()
      formData = JSON.stringify($(this).serializeArray())
      console.log(formData)
      $('.transaction-spinner').css('visibility', 'visible')
      $.post('/transactions', formData)
      .fail( () ->
        $('.transaction-spinner').css('visibility', 'hidden')
        $('#newTransactionOverlay').css('visibility', 'hidden')
        $('.dashboard-container').prepend("<div class='slider message error'>Transaction Failed<span id='closeMessage' class='fa fa-close'></span></div>")
        $('#closeMessage').click( () ->
          $('.message').addClass('closed')
          $('.message').remove()
          true
        )
      ).done( (data) ->
        $('.transaction-spinner').css('visibility', 'hidden')
        $('#newTransactionOverlay').css('visibility', 'hidden')
        $('.dashboard-container').prepend("<div class='slider message success'>Transaction Added Successfully<span id='closeMessage' class='fa fa-close'></span></div>")
        $('#closeMessage').click( () ->
          $('.message').addClass('closed')
          $('.message').remove()
          true
        )
        true
      );
      true
    );
    true


module.exports = TransactionForm
