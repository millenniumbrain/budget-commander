$ = require 'jquery'

class Form
  constructor: (form) ->
    @form = $(form)

  submit: () =>
    @form.on("submit")
