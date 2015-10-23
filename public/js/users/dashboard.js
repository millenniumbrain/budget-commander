/*global accounting*/
/*global _*/

var floatToCurrency = function(number) {
  // parse return floats with scientific notation
  var numberFloated = parseFloat(number);
  // have accounting format the currency
  return accounting.formatMoney(numberFloated);
};

var addTransactions = function(data) {
  var transactionActivity = document.querySelector("#activity tbody");
  
  data.map(function(transaction) {
    var row = document.createElement("tr");
    row.setAttribute("class", "transaction");
    var date = document.createElement("td");
    var description = document.createElement("td");
    var amount = document.createElement("td");
    var accountName = document.createElement("td");

    date.innerHTML = transaction.created_at;
    description.innerHTML = transaction.description;
    amount.innerHTML = floatToCurrency(transaction.amount);
    accountName.innerHTML = transaction.account_id;
    row.appendChild(date);
    row.appendChild(amount);
    row.appendChild(description);
    row.appendChild(accountName);

    transactionActivity.appendChild(row);
  });
};

(function() {

  var request = new XMLHttpRequest();

  request.open("GET", "/users/accounts/transactions", true);

  request.onload = function() {
    if (request.status >= 200 && request.status < 400) {
      var data = JSON.parse(request.responseText);
      addTransactions(data);
    }
    else {

    }
  };

  request.onerror = function() {

  };
  request.send();
})();