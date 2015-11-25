function TransactionForm() {
  this.$form = $("#formTransactions");
}

TransactionForm.prototype = {
  setInputValue: function (el, type, name, value) {
    var $input = $("#transactionForm input:" + type + "[name=" + name + "]");
    $input.val(value);
  },

  submit: function() {
    this.$form.on("submit", function(event) {
      event.preventDefault();
      var formData = JSON.stringify($(this).serializeArray());
      $.post('/users/transactions', formData)
        .success(function(formData){
          console.log("Successfully loaded!");
        });
    });
  }
};

var tranForm = new TransactionForm();
tranForm.submit();
