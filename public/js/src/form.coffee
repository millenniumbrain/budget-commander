class Form
  constructor: (form) ->
    @form = $(form)

  submit: () =>
    @form.on("submit", (event) ->
      event.preventDefault()
      formData = JSON.stringify($(this).serializeArray())
      console.log(formData)
      $.post("/users/transactions", formData)
        .success( (formData) ->
          console.log("Successfully Loaded!")
          true
        );
      true
    );
    true

tranForm = new Form("#formTransactions")
tranForm.submit()
