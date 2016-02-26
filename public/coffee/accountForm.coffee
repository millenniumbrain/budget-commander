$ = require 'jquery'
Form = require './form'

class AccountForm
  constructor: (form) ->
    @form = $(form)

  submit: () =>
    @form.on("submit", (event) ->
      event.preventDefault()
      formData = JSON.stringify($(this).serializeArray())
      console.log(formData)
      $('.account-spinner').css('visibility', 'visible')
      $.post('/accounts', formData)
      .fail( () ->
        $('.account-spinner').css('visibility', 'hidden')
        $('#newAccountOverlay').css('visibility', 'hidden')
        $('.dashboard-container').prepend("<div class='slider message error'>Account Failed<span id='closeMessage' class='fa fa-close'></span></div>")
        $('#closeMessage').click( () ->
          $('.message').addClass('closed')
          $('.message').remove()
          true
        )
      ).done( (data) ->
        $('.account-spinner').css('visibility', 'hidden')
        $('#newAccountOverlay').css('visibility', 'hidden')
        $('.dashboard-container').prepend("<div class='slider message success'>Account Added Successfully<span id='closeMessage' class='fa fa-close'></span></div>")
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


module.exports = AccountForm
